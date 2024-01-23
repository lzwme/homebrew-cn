cask "fedistar" do
  version "1.8.2"
  sha256 "db50bef4c867841f87e07bbc9423a42f3382854f6f14bb08a031e8f616e926af"

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