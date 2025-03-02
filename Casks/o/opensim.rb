cask "opensim" do
  version "0.4.3"
  sha256 "4390edc443be22b5659ff9d6f69a66e0021c9f57e063147be79600235ceadfdb"

  url "https:github.comluoshengOpenSimreleasesdownload#{version}OpenSim.app.zip"
  name "OpenSim"
  desc "Open-source alternative to SimPholders, written in Swift"
  homepage "https:github.comluoshengOpenSim"

  deprecate! date: "2025-03-01", because: :unmaintained

  app "OpenSim.app"

  caveats do
    requires_rosetta
  end
end