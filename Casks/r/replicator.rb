cask "replicator" do
  version "8.0.2"
  sha256 "82685c2c8f10a63251d77b77b2f3103500f90ba1f10bd98bb0730b3ff2317c56"

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