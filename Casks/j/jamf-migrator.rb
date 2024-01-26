cask "jamf-migrator" do
  version "7.4.2"
  sha256 "b66344e420810342849ae8509dc8bf16a0df5a4d7d5759ea6ecad9a030699988"

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