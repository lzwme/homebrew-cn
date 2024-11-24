cask "clash-verge-rev" do
  arch arm: "aarch64", intel: "x64"

  version "2.0.0"
  sha256 arm:   "84ed001c55d6ba78244cd1eacf72b83b3e79674a009417db9c82361a171324bc",
         intel: "4b4332e06691a9228bb3313a53a58b9c17d594888858ff2d008e0f19c64cd380"

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