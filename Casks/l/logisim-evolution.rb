cask "logisim-evolution" do
  version "3.8.0"
  sha256 "6e898653e14e62adc724f613f00af6232f6b53e26999c8af099246b2c06ee803"

  url "https:github.comlogisim-evolutionlogisim-evolutionreleasesdownloadv#{version}Logisim-evolution-#{version}.dmg"
  name "Logisim Evolution"
  desc "Digital logic designer and simulator"
  homepage "https:github.comlogisim-evolutionlogisim-evolution"

  app "Logisim-evolution.app"

  zap trash: "~LibraryPreferencescom.cburch.logisim.plist"
end