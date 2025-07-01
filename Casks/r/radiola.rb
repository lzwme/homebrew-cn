cask "radiola" do
  version "9.2.0"
  sha256 "c8db756d95d4804b3e3779c5f84273cc0a1fb8ecb1f75c2df96b13fb550fcf8b"

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