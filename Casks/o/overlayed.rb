cask "overlayed" do
  version "0.6.1"
  sha256 "195a395f39c58f965cb9bfea987a4446abe5526684a73e3dc2e2c35eafb67a5d"

  url "https:github.comoverlayeddevoverlayedreleasesdownloadv#{version}overlayed_#{version}_universal.dmg",
      verified: "github.comoverlayeddevoverlayed"
  name "Overlayed"
  desc "Modern, open-source, and free voice chat overlay for Discord"
  homepage "https:overlayed.dev"

  depends_on macos: ">= :high_sierra"

  app "Overlayed.app"

  zap trash: "~LibraryApplication Supportcom.hacksore.overlayed"
end