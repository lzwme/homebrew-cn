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

    version "3.0.6"
    sha256 arm:   "7e8609fffe701fb110bd0eaf7ad1561e5d9b48e73fc98f209c15aea8926f44c5",
           intel: "52172525286f6ea13dc166df63f734c754b4154962b9921a05c011d97161dcbe"

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