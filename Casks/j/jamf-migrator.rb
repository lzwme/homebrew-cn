cask "jamf-migrator" do
  version "7.3.1"
  sha256 "18f3a21dca3cc142d300a6f0a0015e2d02adf0301d2fc86ce796dd07de7ebb22"

  url "https:github.comjamfJamfMigratorreleasesdownloadv#{version}jamf-migrator.zip"
  name "JamfMigrator"
  desc "Tool to migrate data granularly between Jamf Pro servers"
  homepage "https:github.comjamfJamfMigrator"

  depends_on macos: ">= :high_sierra"

  app "jamf-migrator.app"

  zap trash: [
    "~LibraryApplication Scriptscom.jamf.jamf-migrator",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.jamf.jamf-migrator.sfl*",
    "~LibraryContainerscom.jamf.jamf-migrator",
  ]
end