cask "calibrite-profiler" do
  version "1.3.2"
  sha256 "ac3ef76116de2efec11fbe67c68b1ba0ba225fa3108831788df5985d3a6dca50"

  url "https:github.comLUMESCAcalibrite-profiler-releasesreleasesdownloadv#{version}calibrite-PROFILER-#{version}.dmg",
      verified: "github.comLUMESCAcalibrite-profiler-releases"
  name "calibrite PROFILER"
  desc "Display calibration software for Calibrite, ColorChecker and X-Rite devices"
  homepage "https:calibrite.comcalibrite-profiler"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "calibrite PROFILER.app"

  zap trash: [
    "~LibraryApplication Supportcalibrite PROFILER",
    "~LibraryApplication Supportcalibrite-profiler",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.calibrite.profiler.sfl*",
    "~LibraryCachescalibrite PROFILER",
    "~LibraryLogscalibrite PROFILER",
    "~LibraryLogscalibrite-profiler",
    "~LibraryPreferencescom.calibrite.profiler.plist",
    "~LibrarySaved Application Statecom.calibrite.profiler.savedState",
  ]

  caveats do
    requires_rosetta
  end
end