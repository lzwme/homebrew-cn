cask "cellprofiler" do
  version "4.2.8"
  sha256 "bb9bf8e90cb0271453ec3e77d5f55e923a0d98485d99bde4a877130978efc52c"

  url "https:github.comCellProfilerCellProfilerreleasesdownloadv#{version}CellProfiler-macOS-#{version}.zip",
      verified: "github.comCellProfilerCellProfiler"
  name "CellProfiler"
  desc "Open-source application for biological image analysis"
  homepage "https:cellprofiler.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "CellProfiler.app"

  zap trash: [
    "~LibraryCachesorg.cellprofiler.CellProfiler",
    "~LibraryPreferencesCellProfilerLocal.cfg",
    "~LibraryPreferencesorg.cellprofiler.CellProfiler.plist",
    "~LibrarySaved Application Stateorg.cellprofiler.CellProfiler.savedState",
    "~LibraryWebkitorg.cellprofiler.CellProfiler",
  ]

  caveats do
    requires_rosetta
  end
end