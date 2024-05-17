cask "fedistar" do
  version "1.9.5"
  sha256 "5ec0737fb2335217df4e309c89809633a3b1e5a92afeb2f030e6e230963e10eb"

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