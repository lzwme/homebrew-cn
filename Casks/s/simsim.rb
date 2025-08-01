cask "simsim" do
  version "1.4.6"
  sha256 "238ecc00803523e4e7ec33aa470179668c8230badabba43eec23c2515e1f6507"

  url "https://ghfast.top/https://github.com/dsmelov/simsim/releases/download/#{version}/SimSim_#{version}.zip"
  name "SimSim"
  desc "Tool to explore iOS application folders in Terminal or Finder"
  homepage "https://github.com/dsmelov/simsim/"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :high_sierra"

  app "SimSim.app"

  uninstall quit: "com.dsmelov.SimSim"

  zap trash: "~/Library/Preferences/com.dsmelov.SimSim.plist"
end