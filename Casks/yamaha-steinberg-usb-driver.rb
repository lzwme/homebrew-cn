cask "yamaha-steinberg-usb-driver" do
  version "3.1.6"
  sha256 "2e6f2ad37509f8bd5ea172850c14e691b50cd399525a974acd697bc650b6109a"

  url "https://download.steinberg.net/downloads_hardware/Yamaha_Steinberg_USB_Driver/Mac/#{version}/YSUSB_V#{version.delete(".")}_Mac.zip"
  name "Yamaha Steinberg USB Driver"
  desc "USB driver for Yamaha Steinberg devices"
  homepage "https://o.steinberg.net/de/support/downloads_hardware/yamaha_steinberg_usb_driver.html"

  livecheck do
    url :homepage
    regex(%r{href=.*?Yamaha_Steinberg_USB_Driver/Mac/(\d+(?:\.\d+)+)/YSUSB_V\d+_Mac.zip}i)
  end

  auto_updates false

  pkg "YSUSB_V#{version.delete(".")}_Mac/Yamaha Steinberg USB Driver V#{version}.pkg"

  uninstall script: {
    executable: "#{staged_path}/YSUSB_V#{version.delete(".")}_Mac/Uninstall Yamaha Steinberg USB Driver.app/Contents/Resources/Scripts/delpkg.sh",
    sudo:       true,
  }

  caveats do
    reboot
  end
end