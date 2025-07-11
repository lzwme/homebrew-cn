cask "opensim" do
  version "0.4.3"
  sha256 "4390edc443be22b5659ff9d6f69a66e0021c9f57e063147be79600235ceadfdb"

  url "https://ghfast.top/https://github.com/luosheng/OpenSim/releases/download/#{version}/OpenSim.app.zip"
  name "OpenSim"
  desc "Open-source alternative to SimPholders, written in Swift"
  homepage "https://github.com/luosheng/OpenSim/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2025-03-01", because: :unmaintained

  app "OpenSim.app"

  caveats do
    requires_rosetta
  end
end