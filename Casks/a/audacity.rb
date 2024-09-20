cask "audacity" do
  arch arm: "arm64", intel: "x86_64"

  version "3.6.4"
  sha256 arm:   "8d1aa3f7529e3e112aaf649385ae7ce7506a05955782f54743d09440cec14bfe",
         intel: "afab4f232c9dfedced418208a77ea781869d05e1109e98d1bd727662a350347a"

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