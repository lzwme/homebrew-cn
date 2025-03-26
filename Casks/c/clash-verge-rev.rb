cask "clash-verge-rev" do
  arch arm: "aarch64", intel: "x64"

  version "2.2.2"
  sha256 arm:   "007c78c98acd3f6fbe889c21dc746227b208d63875c27be0810d8bdf33960469",
         intel: "8045fe203859d95d4975f573b55338c950d3254786b3b6856b0d3e593dc1a696"

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