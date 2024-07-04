cask "overlayed" do
  version "0.4.0"
  sha256 "37946225c2be8db6d9ddc28d5b0510dac209b4f433ae4b916f7d0a2b52f76c48"

  url "https:github.comoverlayeddevoverlayedreleasesdownloadv#{version}overlayed_#{version}_universal.dmg",
      verified: "github.comoverlayeddevoverlayed"
  name "Overlayed"
  desc "Modern, open-source, and free voice chat overlay for Discord"
  homepage "https:overlayed.dev"

  depends_on macos: ">= :high_sierra"

  app "Overlayed.app"

  zap trash: "~LibraryApplication Supportcom.hacksore.overlayed"
end