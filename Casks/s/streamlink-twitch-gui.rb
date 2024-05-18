cask "streamlink-twitch-gui" do
  version "2.5.2"
  sha256 "bb653d1d358e462fb80f238fe031fa7842fd064d829a67a1fc8f184bb6933a1a"

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