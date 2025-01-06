cask "streamlink-twitch-gui" do
  version "2.5.3"
  sha256 "164179e26ef07cc821e718a9a965ed58815de22be080d0fe32e90356a9b850fe"

  url "https:github.comstreamlinkstreamlink-twitch-guireleasesdownloadv#{version}streamlink-twitch-gui-v#{version}-macOS.tar.gz"
  name "Streamlink Twitch GUI"
  desc "Multi platform Twitch.tv browser for Streamlink"
  homepage "https:github.comstreamlinkstreamlink-twitch-gui"

  depends_on formula: "streamlink"
  depends_on macos: ">= :catalina"

  app "Streamlink Twitch GUI.app"

  zap trash: [
    "~LibraryApplication Supportstreamlink-twitch-gui",
    "~LibraryCachesstreamlink-twitch-gui",
    "~LibraryLogsstreamlink-twitch-gui",
  ]

  caveats do
    requires_rosetta
  end
end