cask "logisim-evolution" do
  arch arm: "aarch64", intel: "x86_64"

  version "3.9.0"
  sha256 arm:   "960ee04ed149a80df6f447e689fb0a42f0cc5e9e6986a62582a730a9d191824e",
         intel: "74c89840b492dd5eeadc88b4baf2525b8c74eb37f35bbec2a268e405afc0d6aa"

  url "https:github.comlogisim-evolutionlogisim-evolutionreleasesdownloadv#{version}Logisim-evolution-#{version}-#{arch}.dmg"
  name "Logisim Evolution"
  desc "Digital logic designer and simulator"
  homepage "https:github.comlogisim-evolutionlogisim-evolution"

  no_autobump! because: :requires_manual_review

  app "Logisim-evolution.app"

  zap trash: "~LibraryPreferencescom.cburch.logisim.plist"
end