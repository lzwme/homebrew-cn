cask "replicator" do
  version "8.0.0"
  sha256 "68943248106a3b0c737e1d3bac3d3ba24fb7817cc4e54678d0f90783c6f0b504"

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