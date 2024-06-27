cask "clash-verge-rev" do
  arch arm: "aarch64", intel: "x64"

  version "1.6.6"
  sha256 arm:   "b2e9759533fc253617a54d75a185436146cf9da6c9d101997f0e1b962f7ae573",
         intel: "90eb3a5f5a8175d73e63616e4e9afff7db4b438924b9854963bf8f06230c9cc8"

  url "https:github.comclash-verge-revclash-verge-revreleasesdownloadv#{version}Clash.Verge_#{version}_#{arch}.dmg",
      verified: "github.comclash-verge-revclash-verge-rev"
  name "Clash Verge Rev"
  desc "Continuation of Clash Verge - A Clash Meta GUI based on Tauri"
  homepage "https:clash-verge-rev.github.io"

  depends_on macos: ">= :catalina"

  app "Clash Verge.app"

  zap trash: [
    "~LibraryApplication Supportio.github.clash-verge-rev.clash-verge-rev",
    "~LibraryCachesio.github.clash-verge-rev.clash-verge-rev",
    "~LibraryWebKitio.github.clash-verge-rev.clash-verge-rev",
  ]
end