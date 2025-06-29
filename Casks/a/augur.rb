cask "augur" do
  version "1.16.11"
  sha256 "127a57ed9e3e0b2bd0451f0b097d5998f3e59acb7c4b9d424166f460a1776411"

  url "https:github.comAugurProjectaugur-appreleasesdownloadv#{version}mac-Augur-#{version}.dmg"
  name "Augur"
  desc "App that bundles Augur UI and Augur Node together and deploys them locally"
  homepage "https:github.comAugurProjectaugur-app"

  no_autobump! because: :requires_manual_review

  app "augur.app"

  zap trash: [
    "~LibraryApplication Supportaugur",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsnet.augur.augur.sfl*",
    "~LibraryLogsaugur",
    "~LibraryPreferencesnet.augur.augur.plist",
    "~LibrarySaved Application Statenet.augur.augur.savedState",
  ]

  caveats do
    requires_rosetta
  end
end