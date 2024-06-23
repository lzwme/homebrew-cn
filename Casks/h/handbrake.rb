cask "handbrake" do
  version "1.8.1"
  sha256 "6ce7a063acdd8c4c55b79543181d1e8ff251d0d40e8d4e573d218708473cd4a8"

  url "https:github.comHandBrakeHandBrakereleasesdownload#{version}HandBrake-#{version}.dmg",
      verified: "github.comHandBrakeHandBrake"
  name "HandBrake"
  desc "Open-source video transcoder"
  homepage "https:handbrake.fr"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "HandBrake.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsfr.handbrake.handbrake.sfl*",
    "~LibraryApplication SupportHandBrake",
    "~LibraryCachesfr.handbrake.HandBrake",
    "~LibraryPreferencesfr.handbrake.HandBrake.plist",
    "~LibrarySaved Application Statefr.handbrake.HandBrake.savedState",
  ]
end