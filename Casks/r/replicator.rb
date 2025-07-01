cask "replicator" do
  version "8.1.1"
  sha256 "7144609cd1e4d72665163013ef8da16f6a51358e444dc023522c8fafa9a05c18"

  url "https:github.comjamfReplicatorreleasesdownloadv#{version}Replicator.zip"
  name "Replicator"
  desc "Tool to migrate data granularly between Jamf Pro servers"
  homepage "https:github.comjamfReplicator"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :ventura"

  app "Replicator.app"

  zap trash: [
    "~LibraryApplication Scriptscom.jamf.jamf-migrator",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.jamf.jamf-migrator.sfl*",
    "~LibraryContainerscom.jamf.jamf-migrator",
  ]
end