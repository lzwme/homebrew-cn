cask "pallotron-yubiswitch" do
  version "0.17"
  sha256 "48787eadef7df2383a508587ff93932f35800c146c808269def5db99f6dc869c"

  url "https:github.compallotronyubiswitchreleasesdownloadv#{version}yubiswitch_#{version}.dmg"
  name "Yubiswitch"
  desc "Status bar application to enabledisable Yubikey Nano"
  homepage "https:github.compallotronyubiswitch"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "yubiswitch.app"

  zap trash: [
    "LibraryLaunchDaemonscom.pallotron.yubiswitch.helper.plist",
    "LibraryPrivilegedHelperToolscom.pallotron.yubiswitch.helper",
    "~LibraryPreferencescom.pallotron.yubiswitch.plist",
  ]
end