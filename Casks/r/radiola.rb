cask "radiola" do
  version "8.1.1"
  sha256 "22d681c31fe172ec7d2e493446f457f70cbd3026eed224527a45a27df632d394"

  url "https:github.comSokoloffAradiolareleasesdownloadv#{version}Radiola-#{version}.dmg"
  name "Radiola"
  desc "Internet radio player for the menu bar"
  homepage "https:github.comSokoloffAradiola"

  livecheck do
    url "https:sokoloffa.github.ioradiolafeed.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Radiola.app"

  uninstall quit: "com.github.SokoloffA.Radiola"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.github.sokoloffa.radiola.sfl*",
    "~LibraryApplication Supportcom.github.SokoloffA.Radiola",
    "~LibraryApplication SupportRadiola",
    "~LibraryCachescom.github.SokoloffA.Radiola",
    "~LibraryHTTPStoragescom.github.SokoloffA.Radiola",
    "~LibraryHTTPStoragescom.github.SokoloffA.Radiola.binarycookies",
    "~LibraryPreferencescom.github.SokoloffA.Radiola.plist",
  ]
end