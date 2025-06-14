cask "app-fair" do
  version "0.8.137"
  sha256 "c4a99410058cef2a3c7ac6bb073cf4cac06fb64f7c597140cbf0958e37fe2480"

  url "https:github.comApp-FairAppreleasesdownload#{version}App-Fair-macOS.zip",
      verified: "github.comApp-FairApp"
  name "App Fair"
  desc "Catalogue of free and commercial native desktop applications"
  homepage "https:appfair.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :monterey"

  app "App Fair.app"
  binary "#{appdir}App Fair.appContentsMacOSApp Fair", target: "app-fair"

  zap trash: [
        "~LibraryApplication Scriptsapp.App-Fair",
        "~LibraryApplication Supportapp.App-Fair",
        "~LibraryCachesapp.App-Fair",
        "~LibraryContainersapp.App-Fair",
        "~LibraryHTTPStoragesapp.App-Fair",
        "~LibraryHTTPStoragesapp.App-Fair.binarycookies",
        "~LibraryPreferencesapp.App-Fair.plist",
        "~LibrarySaved Application Stateapp.App-Fair.savedState",
      ],
      rmdir: "ApplicationsApp Fair"
end