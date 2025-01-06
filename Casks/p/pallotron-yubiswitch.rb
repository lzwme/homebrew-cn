cask "pallotron-yubiswitch" do
  version "0.17"
  sha256 "da18d8059e42dfe71abaa7211d7da80f4b5f7f0c1c18bad104bd11a0885b633f"

  url "https:github.compallotronyubiswitchreleasesdownloadv#{version}yubiswitch_#{version}.dmg"
  name "Yubiswitch"
  desc "Status bar application to enabledisable Yubikey Nano"
  homepage "https:github.compallotronyubiswitch"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "yubiswitch.app"

  zap trash: [
    "LibraryLaunchDaemonscom.pallotron.yubiswitch.helper.plist",
    "LibraryPrivilegedHelperToolscom.pallotron.yubiswitch.helper",
    "~LibraryPreferencescom.pallotron.yubiswitch.plist",
  ]
end