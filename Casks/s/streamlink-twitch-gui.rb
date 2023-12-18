cask "streamlink-twitch-gui" do
  version "2.4.1"
  sha256 "6cea7d3faa97f72962fae7049ba84f2fe5dc1110b3e70660c77dde890df3180a"

  url "https:github.comstreamlinkstreamlink-twitch-guireleasesdownloadv#{version}streamlink-twitch-gui-v#{version}-macOS.tar.gz"
  name "Streamlink Twitch GUI"
  desc "Multi platform Twitch.tv browser for Streamlink"
  homepage "https:github.comstreamlinkstreamlink-twitch-gui"

  depends_on formula: "streamlink"

  app "Streamlink Twitch GUI.app"

  zap trash: [
    "~LibraryApplication Supportstreamlink-twitch-gui",
    "~LibraryCachesstreamlink-twitch-gui",
    "~LibraryLogsstreamlink-twitch-gui",
  ]
end