cask "replicator" do
  version "8.1.0"
  sha256 "2bb370c96aaa51f9938705045ac4295f6462e2e1d57bb4e6f5c37f3984140b84"

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