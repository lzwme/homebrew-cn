cask "epson-printer-drivers" do
  version "12.62"
  sha256 :no_check

  url "https://download.epson-europe.com/pub/download/6515/epson651532eu.dmg",
      verified: "download.epson-europe.com/"
  name "Epson Printer Drivers"
  desc "Drivers for Epson printers"
  homepage "https://epson.com/"

  pkg "EPSON Printer.pkg"

  uninstall pkgutil: [
    "com.epson.pkg.ijpdrv.epsonstylusofficebx305plus.w.Machine_106_and_later",
    "com.epson.pkg.ijpdrv.epsonstylusofficebx305plus.w.Module_106_1015",
    "com.epson.pkg.ijpdrv.epsonstylusofficebx305plus.w.Module_110_and_later",
    "com.epson.pkg.ijpdrv.epsonstylusofficebx305plus.w.USBClassDriver",
    "com.epson.pkg.ijpdrv.epsonstylusofficebx305plus.w.USBClassDriver_107_and_later",
  ]
end