cask "overlayed" do
  version "0.6.2"
  sha256 "b47a390708350d98e524bdc87a06d7e634bdc95e0c4092d06b9f92702b7ed946"

  url "https:github.comoverlayeddevoverlayedreleasesdownloadv#{version}overlayed_#{version}_universal.dmg",
      verified: "github.comoverlayeddevoverlayed"
  name "Overlayed"
  desc "Modern, open-source, and free voice chat overlay for Discord"
  homepage "https:overlayed.dev"

  depends_on macos: ">= :high_sierra"

  app "Overlayed.app"

  zap trash: "~LibraryApplication Supportcom.hacksore.overlayed"
end