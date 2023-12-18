cask "simsim" do
  version "1.4.6"
  sha256 "238ecc00803523e4e7ec33aa470179668c8230badabba43eec23c2515e1f6507"

  url "https:github.comdsmelovsimsimreleasesdownload#{version}SimSim_#{version}.zip"
  name "SimSim"
  desc "Tool to explore iOS application folders in Terminal or Finder"
  homepage "https:github.comdsmelovsimsim"

  depends_on macos: ">= :high_sierra"

  app "SimSim.app"

  uninstall quit: "com.dsmelov.SimSim"

  zap trash: "~LibraryPreferencescom.dsmelov.SimSim.plist"
end