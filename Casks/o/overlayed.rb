cask "overlayed" do
  version "0.3.0"
  sha256 "85284c4cceb49663cf7d474da1a9efad9b0465aec5018df00f3e302385723845"

  url "https:github.comHacksoreoverlayedreleasesdownloadv#{version}overlayed_#{version}_universal.dmg",
      verified: "github.comHacksoreoverlayed"
  name "Overlayed"
  desc "Modern, open-source, and free voice chat overlay for Discord"
  homepage "https:overlayed.dev"

  depends_on macos: ">= :high_sierra"

  app "Overlayed.app"

  zap trash: "~LibraryApplication Supportcom.hacksore.overlayed"
end