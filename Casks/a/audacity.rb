cask "audacity" do
  arch arm: "arm64", intel: "x86_64"

  version "3.6.2"
  sha256 arm:   "504a56ab039376b9b7d765211f87e64538ad5ad47fcd78ce5b241ae8e010b29b",
         intel: "f6b19c1930d4173add2cd987dc0ef5961f894929bb2e61757f6d06dbbda6c770"

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