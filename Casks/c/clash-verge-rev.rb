cask "clash-verge-rev" do
  arch arm: "aarch64", intel: "x64"

  version "1.7.5"
  sha256 arm:   "8268db2a3c45f910aa9092e3ac5a44876cbf139398bc5604ab362f35c764f9ab",
         intel: "6d2c76572b2e83929c071649262b02d8aec03be0d8d28aa793ddffe104954ba0"

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