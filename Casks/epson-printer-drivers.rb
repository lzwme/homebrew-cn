cask "epson-printer-drivers" do
  version "13.26,666991"
  sha256 "8491d226aa0c9c74f657a17e221aaad61cc3c5f43d3786316a9a1da8970e3170"

  url "https://download.epson-europe.com/pub/download/#{version.csv.second[0, 4]}/epson#{version.csv.second}eu.dmg",
      verified: "download.epson-europe.com/"
  name "Epson Printer Drivers"
  desc "Drivers for Epson printers"
  homepage "https://epson.com/"

  pkg "EPSON Printer.pkg"

  uninstall pkgutil: [
    "com.epson.pkg.ijpdrv.wf-2960series.w.Machine_106_and_later",
    "com.epson.pkg.ijpdrv.wf-2960series.w.Module_110_and_later",
    "com.epson.pkg.ijpdrv.wf-2960series.w.USBClassDriver_107_and_later",
  ]
end