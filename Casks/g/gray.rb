cask "gray" do
  version "0.17.0"
  sha256 "631e13cf28bae804e7e1a77cddaf2277f91d2de0c45c6fd7805a7c0eac627edd"

  url "https:github.comzenangstGrayreleasesdownload#{version}Gray.zip"
  name "Gray"
  desc "Tool to set light or dark appearance on a per-app basis"
  homepage "https:github.comzenangstGray"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :mojave"

  app "Gray.app"

  zap trash: [
    "~LibraryApplication Scriptscom.zenangst.Gray",
    "~LibraryCachescom.zenangst.Gray",
    "~LibraryGroup Containerscom.zenangst.Gray",
    "~LibraryHTTPStoragescom.zenangst.Gray",
    "~LibraryPreferencescom.zenangst.Gray.plist",
    "~LibrarySaved Application Statecom.zenangst.Gray.savedState",
  ]
end