cask "calibrite-profiler" do
  version "1.3.1"
  sha256 "8adce527e8aeb9d271405a4c9fc865e24498494eae282f32268ed3a495982691"

  url "https:github.comLUMESCAcalibrite-profiler-releasesreleasesdownloadv#{version}calibrite-PROFILER-#{version}.dmg",
      verified: "github.comLUMESCAcalibrite-profiler-releases"
  name "calibrite PROFILER"
  desc "Display calibration software for Calibrite, ColorChecker and X-Rite devices"
  homepage "https:calibrite.comcalibrite-profiler"

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
end