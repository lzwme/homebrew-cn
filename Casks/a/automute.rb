cask "automute" do
  version "1.1"
  sha256 "9c9991790d947cb75c3e21088392c5cfe0d4da0bbc631b5d10abe1fc20353130"

  url "https:github.comLorenzo45AutoMutereleasesdownloadv#{version}AutoMute.zip"
  name "AutoMute"
  desc "Mute or unmute the system based on the current Wi-Fi network"
  homepage "https:github.comLorenzo45AutoMute"

  app "AutoMute.app"

  caveats do
    requires_rosetta
  end
end