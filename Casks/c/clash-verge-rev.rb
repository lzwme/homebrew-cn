cask "clash-verge-rev" do
  arch arm: "aarch64", intel: "x64"

  version "1.7.6"
  sha256 arm:   "cd1a160e8fb7b12944b01a8925fdf2991241b493b05d1f61666c3de95d48a155",
         intel: "28b0f232c5003ef609896f44b4fb9e73f3e47dfd86f27c69062f9eb949dd2ee2"

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