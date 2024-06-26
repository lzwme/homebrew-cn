cask "mission-control-plus" do
  version "1.23"
  sha256 "58ffd154bad723dbd413bb793b389c81e60f5a57611dae32e87c2fea65f2597b"

  url "https:github.comronyfadelMissionControlPlusReleasesreleasesdownloadv#{version}Mission.Control.Plus.tgz",
      verified: "github.comronyfadelMissionControlPlusReleases"
  name "Mission Control Plus"
  desc "Manage your windows in Mission Control"
  homepage "https:fadel.ioMissionControlPlus"

  depends_on macos: ">= :high_sierra"

  app "Mission Control Plus.app"

  zap trash: "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsio.fadel.missioncontrolplus.sfl*"
end