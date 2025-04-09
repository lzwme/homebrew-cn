cask "fedistar" do
  version "1.11.3"
  sha256 "ee410cd5202a58c7a16123fa3f689676c2ee29ad104ff16bd26059d10377c494"

  url "https:github.comh3potetofedistarreleasesdownloadv#{version}fedistar_#{version}_universal.dmg",
      verified: "github.comh3potetofedistar"
  name "fedistar"
  desc "Multi-column Mastodon, Pleroma, and Friendica client for desktop"
  homepage "https:fedistar.net"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sonoma"

  app "fedistar.app"

  zap trash: [
    "~LibraryApplication Scripts*.net.fedistar",
    "~LibraryApplication Scriptsnet.fedistar",
    "~LibraryContainersnet.fedistar",
    "~LibraryGroup Containers*.net.fedistar",
  ]
end