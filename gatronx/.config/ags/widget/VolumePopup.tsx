import app from "ags/gtk4/app"
import { Astal, Gtk } from "ags/gtk4"
import { createBinding } from "ags"
import Wp from "gi://AstalWp"

export default function VolumePopup() {
  const wp = Wp.get_default()
  const speaker = wp!.audio.default_speaker
  const volume = createBinding(speaker, "volume")

  const scale = new Gtk.Scale({
    orientation: Gtk.Orientation.HORIZONTAL,
    hexpand: true,
  })
  scale.set_range(0, 1)
  scale.set_value(speaker.volume)
  scale.connect("value-changed", () => {
    speaker.volume = scale.get_value()
  })
  volume.subscribe(() => {
    scale.set_value(speaker.volume)
  })

  // botón invisible que cubre toda la pantalla, cierra el popup al click
  const closeButton = new Gtk.Button({ hexpand: true, vexpand: true })
  closeButton.add_css_class("click-catcher")
  closeButton.connect("clicked", () => {
    app.get_window("volume-popup")?.set_visible(false)
  })

  // la burbuja en sí, posicionada arriba a la derecha
  const bubble = new Gtk.Box({
    orientation: Gtk.Orientation.VERTICAL,
    halign: Gtk.Align.END,
    valign: Gtk.Align.START,
  })
  bubble.set_margin_top(40)
  bubble.set_margin_end(280)
  bubble.add_css_class("volume-popup-box")
  bubble.append(new Gtk.Label({ label: "Volumen" }))
  bubble.append(scale)

  const overlay = new Gtk.Overlay()
  overlay.set_child(closeButton)
  overlay.add_overlay(bubble)

  return (
    <window
      visible={false}
      name="volume-popup"
      class="VolumePopup"
      anchor={
        Astal.WindowAnchor.TOP |
        Astal.WindowAnchor.BOTTOM |
        Astal.WindowAnchor.LEFT |
        Astal.WindowAnchor.RIGHT
      }
      exclusivity={Astal.Exclusivity.IGNORE}
      application={app}
      keymode={Astal.Keymode.ON_DEMAND}
    >
      {overlay}
    </window>
  )
}
