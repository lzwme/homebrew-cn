cask "handbrake" do
  version "1.8.0"
  sha256 "e203108deaa8eda471fc6d27ca31b361cdd8bfe14ae41602d3581872e11da1a0"

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