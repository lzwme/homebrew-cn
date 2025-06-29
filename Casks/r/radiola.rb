cask "radiola" do
  version "9.0.0"
  sha256 "cd8040ccfe99e336de4d5b65466fbfa940b569171fd29e5ea1093665128e14a3"

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