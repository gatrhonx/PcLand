// ~/.config/ags/widget/NetworkPopup.tsx
//
// Popup de red estilo GNOME quick-settings.
// Sigue el MISMO patrón que VolumePopup.tsx:
//   - Ventana fullscreen con Gtk.Overlay
//   - Capa de fondo = click-catcher transparente (cierra al hacer click afuera)
//   - Capa de arriba = la burbuja real, anclada arriba-derecha
//
// Para el escaneo/listado/conexión de redes se usa `nmcli` directamente
// (vía execAsync). Se hace así a propósito y no con la API de conexión
// de AstalNetwork: esa parte de la librería todavía es limitada/inestable
// para "conectar" (funciona bien para leer estado: ssid activo, señal,
// ícono), así que se combinan las dos cosas: AstalNetwork para el estado
// reactivo, nmcli para las acciones. Es el mismo enfoque que ya usás en
// el script de Waybar (custom/network), solo que ahora con una lista
// interactiva en vez de un solo texto.

import { Astal, Gtk, Gdk } from "astal/gtk4"
import { createState, createBinding, onCleanup } from "ags"
import { execAsync } from "ags/process"
import Network from "gi://AstalNetwork"

// --- Tipos y helpers de nmcli -----------------------------------------

interface WifiNetwork {
  ssid: string
  signal: number
  secured: boolean
  active: boolean
}

// Parsea la salida de:
// nmcli -t -f SSID,SIGNAL,SECURITY,IN-USE dev wifi list
// -t = terse (separado por ":"), fácil de parsear a mano.
function parseNmcliList(output: string): WifiNetwork[] {
  const seen = new Set<string>()
  const networks: WifiNetwork[] = []

  for (const line of output.split("\n")) {
    if (!line.trim()) continue

    // nmcli escapa los ":" del SSID como "\:", por eso el split es un poco
    // más cuidadoso que un simple line.split(":")
    const parts = line.split(/(?<!\\):/).map((p) => p.replace(/\\:/g, ":"))
    const [ssid, signal, security, inUse] = parts

    if (!ssid) continue // redes ocultas sin nombre, las ignoramos
    if (seen.has(ssid)) continue // nmcli repite el SSID por cada BSSID visible
    seen.add(ssid)

    networks.push({
      ssid,
      signal: Number(signal) || 0,
      secured: security !== "--" && security !== "",
      active: inUse === "*",
    })
  }

  // Ordenar: conectada primero, después por señal descendente
  return networks.sort((a, b) => {
    if (a.active !== b.active) return a.active ? -1 : 1
    return b.signal - a.signal
  })
}

async function scanNetworks(): Promise<WifiNetwork[]> {
  await execAsync(["nmcli", "dev", "wifi", "rescan"]).catch(() => {
    // el rescan falla si se pidió hace <30s, no es un error real, se ignora
  })
  const output = await execAsync([
    "nmcli",
    "-t",
    "-f",
    "SSID,SIGNAL,SECURITY,IN-USE",
    "dev",
    "wifi",
    "list",
  ])
  return parseNmcliList(output)
}

function connectToNetwork(ssid: string, password?: string) {
  const cmd = password
    ? ["nmcli", "dev", "wifi", "connect", ssid, "password", password]
    : ["nmcli", "dev", "wifi", "connect", ssid]

  return execAsync(cmd)
}

// --- Ícono de señal ------------------------------------------------------

function signalIcon(signal: number): string {
  if (signal >= 80) return "network-wireless-signal-excellent-symbolic"
  if (signal >= 55) return "network-wireless-signal-good-symbolic"
  if (signal >= 30) return "network-wireless-signal-ok-symbolic"
  if (signal > 0) return "network-wireless-signal-weak-symbolic"
  return "network-wireless-signal-none-symbolic"
}

// --- Fila de una red individual ------------------------------------------

function NetworkRow({
  network,
  expandedSsid,
  setExpandedSsid,
  onConnected,
}: {
  network: WifiNetwork
  expandedSsid: ReturnType<typeof createState<string | null>>[0]
  setExpandedSsid: (v: string | null) => void
  onConnected: () => void
}) {
  const [password, setPassword] = createState("")
  const [connecting, setConnecting] = createState(false)
  const [error, setError] = createState("")

  const isExpanded = () => expandedSsid() === network.ssid

  function handleRowClick() {
    if (network.active) return
    if (!network.secured) {
      // red abierta: conectar directo, sin pedir contraseña
      setConnecting(true)
      connectToNetwork(network.ssid)
        .then(() => onConnected())
        .catch((e) => setError(String(e)))
        .finally(() => setConnecting(false))
      return
    }
    setExpandedSsid(isExpanded() ? null : network.ssid)
  }

  function handleConnectClick() {
    setConnecting(true)
    setError("")
    connectToNetwork(network.ssid, password())
      .then(() => {
        setPassword("")
        setExpandedSsid(null)
        onConnected()
      })
      .catch(() => setError("No se pudo conectar. Revisá la contraseña."))
      .finally(() => setConnecting(false))
  }

  return (
    <box orientation={Gtk.Orientation.VERTICAL} cssClasses={["network-row"]}>
      <button cssClasses={["network-row-button"]} onClicked={handleRowClick}>
        <box spacing={8}>
          <image iconName={signalIcon(network.signal)} />
          <label label={network.ssid} hexpand halign={Gtk.Align.START} />
          {network.active && (
            <image iconName="object-select-symbolic" cssClasses={["network-active-check"]} />
          )}
          {network.secured && !network.active && (
            <image iconName="network-wireless-encrypted-symbolic" />
          )}
        </box>
      </button>

      {isExpanded() && (
        <box orientation={Gtk.Orientation.VERTICAL} cssClasses={["network-password-box"]} spacing={6}>
          <entry
            placeholderText="Contraseña"
            visibility={false}
            text={password()}
            onChanged={(self) => setPassword(self.text)}
            onActivate={handleConnectClick}
          />
          {error() && <label label={error()} cssClasses={["network-error"]} />}
          <button
            cssClasses={["network-connect-button"]}
            sensitive={!connecting()}
            onClicked={handleConnectClick}
          >
            <label label={connecting() ? "Conectando..." : "Conectar"} />
          </button>
        </box>
      )}
    </box>
  )
}

// --- Ventana / burbuja principal -----------------------------------------

export default function NetworkPopup() {
  const network = Network.get_default()
  const wifiEnabled = createBinding(network.wifi, "enabled")
  const currentSsid = createBinding(network.wifi, "ssid")

  const [networks, setNetworks] = createState<WifiNetwork[]>([])
  const [loading, setLoading] = createState(false)
  const [expandedSsid, setExpandedSsid] = createState<string | null>(null)

  function refresh() {
    setLoading(true)
    scanNetworks()
      .then(setNetworks)
      .finally(() => setLoading(false))
  }

  // Escanea apenas se abre el popup por primera vez
  refresh()

  return (
    <window
      visible={false}
      name="network-popup"
      anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.BOTTOM | Astal.WindowAnchor.LEFT | Astal.WindowAnchor.RIGHT}
      exclusivity={Astal.Exclusivity.IGNORE}
      keymode={Astal.Keymode.ON_DEMAND}
      application={App}
    >
      <overlay>
        {/* capa de fondo: click afuera = cerrar, igual que en VolumePopup */}
        <button
          cssClasses={["click-catcher"]}
          onClicked={() => App.get_window("network-popup")?.hide()}
        />

        <box
          $type="overlay"
          orientation={Gtk.Orientation.VERTICAL}
          cssClasses={["network-popup-box"]}
          halign={Gtk.Align.END}
          valign={Gtk.Align.START}
          spacing={8}
          setup={(self) => {
            // mismos márgenes que la burbuja de volumen, para que
            // queden alineadas una debajo de la otra
            self.set_margin_top(46)
            self.set_margin_end(12)
          }}
        >
          <box spacing={8}>
            <label label="Wi-Fi" hexpand halign={Gtk.Align.START} cssClasses={["network-title"]} />
            <button onClicked={refresh} sensitive={!loading()}>
              <image iconName="view-refresh-symbolic" />
            </button>
          </box>

          {!wifiEnabled() && (
            <label label="Wi-Fi desactivado" cssClasses={["network-disabled"]} />
          )}

          {loading() && networks().length === 0 && (
            <label label="Buscando redes..." cssClasses={["network-loading"]} />
          )}

          <box orientation={Gtk.Orientation.VERTICAL} cssClasses={["network-list"]}>
            {networks().map((n) => (
              <NetworkRow
                network={n}
                expandedSsid={[expandedSsid, setExpandedSsid]}
                setExpandedSsid={setExpandedSsid}
                onConnected={refresh}
              />
            ))}
          </box>
        </box>
      </overlay>
    </window>
  )
}
