cask "milkytracker" do
  version "1.05.01"
  sha256 "465e399e5174255f33d92490052c7a851019bf5c9ba798bd83fc384158b05c71"

  url "https:github.commilkytrackerMilkyTrackerreleasesdownloadv#{version}milkytracker-#{version}-Universal.dmg",
      verified: "github.commilkytrackerMilkyTracker"
  name "MilkyTracker"
  desc "Music tracker compatible with FT2"
  homepage "https:milkytracker.titandemo.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "MilkyTracker.app"

  zap trash: "~LibraryPreferencescom.Titan.MilkyTracker.plist"
end