cask "streamlink-twitch-gui" do
  version "2.5.0"
  sha256 "cfbca3d748de0c640566a07255c663f1934a32e3776254426fa02e6fe3516a77"

  url "https:github.comstreamlinkstreamlink-twitch-guireleasesdownloadv#{version}streamlink-twitch-gui-v#{version}-macOS.tar.gz"
  name "Streamlink Twitch GUI"
  desc "Multi platform Twitch.tv browser for Streamlink"
  homepage "https:github.comstreamlinkstreamlink-twitch-gui"

  depends_on formula: "streamlink"
  depends_on macos: ">= :high_sierra"

  app "Streamlink Twitch GUI.app"

  zap trash: [
    "~LibraryApplication Supportstreamlink-twitch-gui",
    "~LibraryCachesstreamlink-twitch-gui",
    "~LibraryLogsstreamlink-twitch-gui",
  ]
end