cask "yamaha-steinberg-usb-driver" do
  version "3.1.7"
  sha256 "1f65ac6823e5e35ad08a4c8650e9ccdc2b71fb8075c3593c353f2232e35f668f"

  url "https://download.steinberg.net/downloads_hardware/Yamaha_Steinberg_USB_Driver/Mac/#{version}/YSUSB_V#{version.no_dots}_Mac.zip"
  name "Yamaha Steinberg USB Driver"
  desc "USB driver for Yamaha Steinberg devices"
  homepage "https://o.steinberg.net/de/support/downloads_hardware/yamaha_steinberg_usb_driver.html"

  livecheck do
    url :homepage
    regex(%r{href=.*?Yamaha_Steinberg_USB_Driver/Mac/(\d+(?:\.\d+)+)/YSUSB_V\d+_Mac.zip}i)
  end

  auto_updates false

  pkg "YSUSB_V#{version.no_dots}_Mac/Yamaha Steinberg USB Driver V#{version}.pkg"

  uninstall script: {
    executable: "#{staged_path}/YSUSB_V#{version.no_dots}_Mac/Uninstall Yamaha Steinberg USB Driver.app/Contents/Resources/Scripts/delpkg.sh",
    sudo:       true,
  }

  caveats do
    reboot
  end
end