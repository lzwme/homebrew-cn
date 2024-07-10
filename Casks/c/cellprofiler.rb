cask "cellprofiler" do
  version "4.2.6"
  sha256 "da25ab0999459f892e31c809593f34d24ffc9cf6deb096bc8059f76688448e0d"

  url "https:github.comCellProfilerCellProfilerreleasesdownloadv#{version}CellProfiler-macOS-#{version}.zip",
      verified: "github.comCellProfilerCellProfiler"
  name "CellProfiler"
  desc "Open-source application for biological image analysis"
  homepage "https:cellprofiler.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "CellProfiler.app"

  caveats do
    requires_rosetta
  end
end