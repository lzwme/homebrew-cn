cask "clash-verge-rev" do
  arch arm: "aarch64", intel: "x64"

  version "2.1.1"
  sha256 arm:   "ff6eafb5dc9911dfbd9b4661084c9612eb7c5a4fe1cdbd65249147e71cacfebf",
         intel: "7bf7626bf7124bad5444b21b2811b37681f0a48f3404c7bf457eff063d258dfb"

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