// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import { Socket } from "phoenix"
import NProgress from "nprogress"
import { LiveSocket } from "phoenix_live_view"

const show_map = (el) => {
    const lat_el = el.querySelector('#lat')
    const lon_el = el.querySelector('#lon')
    const map_id_el = el.querySelector('#map_id')
    const map_id = '#' + map_id_el.value
    const map_el = el.querySelector(map_id)


    if (map_el) {
        // reset the map div
        map_el._leaflet_id = null;
    }

    if (map_el && lat_el && lat_el.value && lon_el && lon_el.value) {
        var lat = parseFloat(lat_el.value)
        var lon = parseFloat(lon_el.value)
        var mymap = L.map(map_el).setView([lat, lon], 17);

        L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
            subdomains: ['a', 'b', 'c']
        }).addTo(mymap);

        L.marker([lat, lon]).addTo(mymap);
    }
}

let Hooks = {}

Hooks.AddMap = {
    mounted() {
        show_map(this.el)

    },
    updated() {
        show_map(this.el)
    }
}


let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, { params: { _csrf_token: csrfToken }, hooks: Hooks })

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

