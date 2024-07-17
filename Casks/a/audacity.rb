cask "audacity" do
  arch arm: "arm64", intel: "x86_64"

  version "3.6.0"
  sha256 arm:   "8674b2bcbcd7c11802d30c01075af08ac0d8f95d627e98cbbfa5b748c557424d",
         intel: "e0a2d4b662c27341b11135b4e3a86d6be3778579fc696d2f5a6ff9ebef00c9f8"

  url "https:github.comaudacityaudacityreleasesdownloadAudacity-#{version}audacity-macOS-#{version}-#{arch}.dmg",
      verified: "github.comaudacityaudacity"
  name "Audacity"
  desc "Multi-track audio editor and recorder"
  homepage "https:www.audacityteam.org"

  livecheck do
    url :url
    regex(^Audacity[._-]v?(\d+(?:\.\d+)+)$i)
  end

  depends_on macos: ">= :high_sierra"

  app "Audacity.app"

  zap trash: [
    "~LibraryApplication Supportaudacity",
    "~LibraryPreferencesorg.audacityteam.audacity.plist",
    "~LibrarySaved Application Stateorg.audacityteam.audacity.savedState",
  ]
end