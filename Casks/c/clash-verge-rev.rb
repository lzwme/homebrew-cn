cask "clash-verge-rev" do
  arch arm: "aarch64", intel: "x64"

  version "1.7.0"
  sha256 arm:   "e0515ab9b4734313e5db1d71325f78f53664d387fb06a89c483aac717f5c9f44",
         intel: "54db2e83f750adf7be89afdeb147d42777098ec79c54876e422fefbb02d124bd"

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