cask "audacity" do
  arch arm: "arm64", intel: "x86_64"

  version "3.7.1"
  sha256 arm:   "4c425a902f91c36aacf5a44b9cae3bde571a5499eb60a0c0f1e79bcede553e9b",
         intel: "b04f1bc17ab15283678ff4f2d026df40ab7cbdc401e71bff4d07257370ef3b36"

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