cask "fedistar" do
  version "1.9.11"
  sha256 "619c8179defb779b45d2d4669ea1842e496d10d4c10bcb56e67778e39e043633"

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