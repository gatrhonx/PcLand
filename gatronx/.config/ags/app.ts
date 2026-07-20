import app from "ags/gtk4/app"
import style from "./style.scss"
import VolumePopup from "./widget/VolumePopup"

app.start({
  css: style,
  main() {
    VolumePopup()
  },
})
