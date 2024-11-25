cask "clash-verge-rev" do
  arch arm: "aarch64", intel: "x64"

  version "2.0.1"
  sha256 arm:   "60dc78d64f0cb8214c69792f3ce670b016b7ded206d1656ded4f2670c3be3d62",
         intel: "14f7d96c4dae7d287afb339ae28169a2f42fe4f075dd8342f5415355aac7cb1c"

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