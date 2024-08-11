cask "handbrake" do
  version "1.8.2"
  sha256 "a59dc16b6aa6ce5041672620b3eebe2e51bb3205e4bd0a562359cbf1323b2d84"

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