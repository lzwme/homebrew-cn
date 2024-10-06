cask "calibrite-profiler" do
  version "1.3.3"
  sha256 "beab575669a526520a20a64f47f510e01471d0631246cfea77ef727d91cea083"

  url "https:github.comLUMESCAcalibrite-profiler-releasesreleasesdownloadv#{version}calibrite-PROFILER-#{version}.dmg",
      verified: "github.comLUMESCAcalibrite-profiler-releases"
  name "calibrite PROFILER"
  desc "Display calibration software for Calibrite, ColorChecker and X-Rite devices"
  homepage "https:calibrite.comcalibrite-profiler"

  # Upstream sometimes marks a release as "pre-release" on GitHub but the
  # first-party download page links to the release as the latest stable
  # version. This checks the download page, which links to the latest dmg file
  # on GitHub without having to worry about latestpre-release.
  livecheck do
    url "https:calibrite.comussoftware-downloads"
    regex(href=.*?calibrite-PROFILER[._-]v?(\d+(?:\.\d+)+)\.dmgi)
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