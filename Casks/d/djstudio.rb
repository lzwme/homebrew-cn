cask "djstudio" do
  on_mojave :or_older do
    version "2.6.28"
    sha256 "a24739ad73b5fbda7c64aaae320b1486622c669ba3dc414d692def6026d2639d"

    url "https:github.comAppMachinedj-studio-app-updatesreleasesdownloadv#{version}DJ.Studio-#{version}.dmg",
        verified: "github.comAppMachinedj-studio-app-updates"

    livecheck do
      skip "Legacy version"
    end
  end
  on_catalina :or_newer do
    arch arm: "-arm64"

    version "3.0.18"
    sha256 arm:   "d97fcdacc5c6683ebb3c58058b53849f22d39ba79221ebdef9dff7cfd105ad5b",
           intel: "022be2f9b0253c615b3b8db6b511c141027c6f8f3e852b0f097827adab5c2a6f"

    url "https:github.comAppMachinedj-studio-app-updatesreleasesdownloadv#{version}DJ.Studio-#{version}#{arch}.dmg",
        verified: "github.comAppMachinedj-studio-app-updates"

    livecheck do
      url :url
      strategy :github_latest
    end
  end

  name "DJ.Studio"
  desc "DAW for DJs"
  homepage "https:dj.studio"

  depends_on macos: ">= :high_sierra"

  app "DJ.Studio.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsdj.studio.app.sfl*",
    "~LibraryApplication SupportDJ.Studio",
    "~LibraryApplication Supportdj.studio.app",
    "~LibraryPreferencesdj.studio.app.plist",
    "~LibrarySaved Application Statedj.studio.app.savedState",
    "~MusicDJ.Studio",
  ]
end