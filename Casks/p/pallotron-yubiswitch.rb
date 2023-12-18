cask "pallotron-yubiswitch" do
  version "0.16"
  sha256 "4ef75931712d44f3ae8f4038f7e59d4f3493b83990a8b3c828858ea3e3ec2a07"

  url "https:github.compallotronyubiswitchreleasesdownloadv#{version}yubiswitch_#{version}.dmg"
  name "Yubiswitch"
  desc "Status bar application to enabledisable Yubikey Nano"
  homepage "https:github.compallotronyubiswitch"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "yubiswitch.app"
end