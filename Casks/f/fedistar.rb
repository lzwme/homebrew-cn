cask "fedistar" do
  version "1.10.0"
  sha256 "130f4866cf19b37ed3f97df0e559b8b868bc61aedcfe854822b516863d8756c8"

  url "https:github.comh3potetofedistarreleasesdownloadv#{version}fedistar_#{version}_universal.dmg",
      verified: "github.comh3potetofedistar"
  name "fedistar"
  desc "Multi-column Mastodon, Pleroma, and Friendica client for desktop"
  homepage "https:fedistar.net"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :ventura"

  app "fedistar.app"

  zap trash: [
    "~LibraryApplication Scripts*.net.fedistar",
    "~LibraryApplication Scriptsnet.fedistar",
    "~LibraryContainersnet.fedistar",
    "~LibraryGroup Containers*.net.fedistar",
  ]
end