cask "viscosity" do
  version "1.10.6"
  sha256 "7ffc96117f9894e05f1f6efb3b5811501f17a5344f6f41ad83a631c0f11a93cb"

  url "https://swupdate.sparklabs.com/download/mac/release/viscosity/Viscosity%20#{version}.dmg"
  name "Viscosity"
  desc "OpenVPN client with AppleScript support"
  homepage "https://www.sparklabs.com/viscosity/"

  livecheck do
    url "https://swupdate.sparklabs.com/appcast/mac/release/viscosity/"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Viscosity.app"

  uninstall delete:    [
              "/Library/Application Support/Viscosity",
              "/Library/PrivilegedHelperTools/com.sparklabs.ViscosityHelper",
            ],
            launchctl: "com.sparklabs.ViscosityHelper",
            signal:    ["TERM", "com.viscosityvpn.Viscosity"]

  zap trash: [
    "~/Library/Application Support/Viscosity",
    "~/Library/Caches/com.plausiblelabs.crashreporter.data/com.viscosityvpn.Viscosity",
    "~/Library/HTTPStorages/com.viscosityvpn.Viscosity",
    "~/Library/Preferences/com.viscosityvpn.Viscosity.plist",
  ]
end