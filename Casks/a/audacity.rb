cask "audacity" do
  arch arm: "arm64", intel: "x86_64"

  version "3.6.1"
  sha256 arm:   "8cbf5044c51b480c45aa1b6453672aa755747ffb51ca996e8561cff21ae27bb1",
         intel: "4305e4d7a98a4fa2a15604824d090308186f17a32670ff026890faeba665ba42"

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