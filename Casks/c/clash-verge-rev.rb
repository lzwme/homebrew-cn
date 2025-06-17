cask "clash-verge-rev" do
  arch arm: "aarch64", intel: "x64"

  version "2.3.0"
  sha256 arm:   "b54582f98595d9f1421494d10bfb3009c7e9d9454f7bbfdaa6295910fbac0944",
         intel: "6cd1bb933cec3bf26630bd031b54b929db7ad0d15659345e42f5d7cb9096b966"

  url "https:github.comclash-verge-revclash-verge-revreleasesdownloadv#{version}Clash.Verge_#{version}_#{arch}.dmg",
      verified: "github.comclash-verge-revclash-verge-rev"
  name "Clash Verge Rev"
  desc "Continuation of Clash Verge - A Clash Meta GUI based on Tauri"
  homepage "https:clash-verge-rev.github.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Clash Verge.app"

  zap trash: [
    "~LibraryApplication Supportio.github.clash-verge-rev.clash-verge-rev",
    "~LibraryCachesio.github.clash-verge-rev.clash-verge-rev",
    "~LibraryWebKitio.github.clash-verge-rev.clash-verge-rev",
  ]
end