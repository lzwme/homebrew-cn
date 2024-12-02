cask "handbrake" do
  version "1.9.0"
  sha256 "91478482165890fd1191aaccd8970dd871b0975e728b73ea3ac4025d821a4193"

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