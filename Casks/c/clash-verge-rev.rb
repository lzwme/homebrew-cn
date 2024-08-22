cask "clash-verge-rev" do
  arch arm: "aarch64", intel: "x64"

  version "1.7.7"
  sha256 arm:   "f01c56e4612691b066eedddcc22177efdd1e486e06b38cd5ab5ebc3d76329ada",
         intel: "ddf94bb368ef086ffd71513f0bf793bdbebd1c9aba94d7ac20f5fa722f05b004"

  url "https:github.comclash-verge-revclash-verge-revreleasesdownloadv#{version}Clash.Verge_#{version}_#{arch}.dmg",
      verified: "github.comclash-verge-revclash-verge-rev"
  name "Clash Verge Rev"
  desc "Continuation of Clash Verge - A Clash Meta GUI based on Tauri"
  homepage "https:clash-verge-rev.github.io"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Clash Verge.app"

  zap trash: [
    "~LibraryApplication Supportio.github.clash-verge-rev.clash-verge-rev",
    "~LibraryCachesio.github.clash-verge-rev.clash-verge-rev",
    "~LibraryWebKitio.github.clash-verge-rev.clash-verge-rev",
  ]
end