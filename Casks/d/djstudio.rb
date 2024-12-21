cask "djstudio" do
  arch arm: "-arm64"

  on_mojave :or_older do
    version "2.6.28"
    sha256 "a24739ad73b5fbda7c64aaae320b1486622c669ba3dc414d692def6026d2639d"

    url "https:github.comAppMachinedj-studio-app-updatesreleasesdownloadv#{version}DJ.Studio-#{version}.dmg"
  end
  on_catalina :or_newer do
    version "3.0.3"
    sha256 arm:   "df0094a03348ad04622eab218044c3239a6d1df9292d47b905c6a0c2f8cebf53",
           intel: "ccad63bcef124d82fd8cb2278e02fb72744456de091902beca4d58c318426589"

    url "https:download.dj.studioDJ.Studio-#{version}#{arch}.dmg"
  end

  name "DJ.Studio"
  desc "DAW for DJs"
  homepage "https:dj.studio"

  livecheck do
    url "https:github.comAppMachinedj-studio-app-updates"
    strategy :github_latest
  end

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