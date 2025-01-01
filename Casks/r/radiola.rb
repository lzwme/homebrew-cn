cask "radiola" do
  version "8.1.0"
  sha256 "96ecfb960e4cc689a7b5045e6168f91d31906cb27f11d13b28a4a6313124f9b3"

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