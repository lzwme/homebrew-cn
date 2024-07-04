cask "clash-verge-rev" do
  arch arm: "aarch64", intel: "x64"

  version "1.7.2"
  sha256 arm:   "0453bb6a02a5187bfd5cb201a37b8bb8f651d8e40356e94033e7e71f00bfa2c9",
         intel: "d165e85e4f9e43cdf4431d8b25facec96fe0be17872ca6259ffe3411427c8d13"

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