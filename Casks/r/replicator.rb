cask "replicator" do
  version "8.0.1"
  sha256 "61e84d051aee336a03ec90c807a3fc355e083c7a159efc7e4b4e2f463b3e6b26"

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