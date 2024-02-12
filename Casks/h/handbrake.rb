cask "handbrake" do
  version "1.7.3"
  sha256 "a4db4c6bfb43cf5aa08c6c27f4a2fa24fc47deaf9c84b78c4185ea3fc9ac46ae"

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