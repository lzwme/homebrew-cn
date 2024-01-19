cask "commandpost" do
  on_mojave :or_older do
    version "1.2.16"
    sha256 "a874240a9c37a77da47c7e3c33342f3cc4d415d3bb146bee4b49b0776e8e08a8"

    livecheck do
      skip "Legacy version"
    end
  end
  on_catalina do
    version "1.4.13"
    sha256 "dd0ddbf94722174760c82870f537b299ce0b1b6265875aa558d515df4338a816"

    livecheck do
      skip "Legacy version"
    end
  end
  on_big_sur :or_newer do
    version "1.4.24"
    sha256 "c7dcf90fa9b4eb708716a6117cf6fc852a953e7b3ef27150dd918da340a7e739"
  end

  url "https:github.comCommandPostCommandPostreleasesdownload#{version}CommandPost_#{version}.dmg",
      verified: "github.comCommandPostCommandPost"
  name "CommandPost"
  desc "Workflow enhancements for Final Cut Pro"
  homepage "https:commandpost.io"

  auto_updates true
  depends_on macos: ">= :sierra"

  app "CommandPost.app"
  binary "#{appdir}CommandPost.appContentsFrameworkshscmdpost"

  uninstall quit:       "org.latenitefilms.CommandPost",
            login_item: "CommandPost"

  zap trash: [
    "~LibraryApplication SupportCommandPost",
    "~LibraryApplication Supportorg.latenitefilms.CommandPost",
    "~LibraryCachescom.apple.nsurlsessiondDownloadsorg.latenitefilms.CommandPost",
    "~LibraryCachescom.crashlytics.dataorg.latenitefilms.CommandPost",
    "~LibraryCachesio.fabric.sdk.mac.dataorg.latenitefilms.CommandPost",
    "~LibraryCachesorg.latenitefilms.CommandPost",
    "~LibraryHTTPStoragesorg.latenitefilms.CommandPost",
    "~LibraryPreferencesorg.latenitefilms.CommandPost.plist",
    "~LibrarySaved Application Stateorg.latenitefilms.CommandPost.savedState",
    "~LibraryWebKitorg.latenitefilms.CommandPost",
  ]
end