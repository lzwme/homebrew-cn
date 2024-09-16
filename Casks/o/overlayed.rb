cask "overlayed" do
  version "0.6.0"
  sha256 "c67b2a661d4a1f236981a1292dd8398f5dd0ad05e2fdf87c788b46a650dc19b4"

  url "https:github.comoverlayeddevoverlayedreleasesdownloadv#{version}overlayed_#{version}_universal.dmg",
      verified: "github.comoverlayeddevoverlayed"
  name "Overlayed"
  desc "Modern, open-source, and free voice chat overlay for Discord"
  homepage "https:overlayed.dev"

  depends_on macos: ">= :high_sierra"

  app "Overlayed.app"

  zap trash: "~LibraryApplication Supportcom.hacksore.overlayed"
end