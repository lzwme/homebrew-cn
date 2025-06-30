cask "radiola" do
  version "9.1.0"
  sha256 "9d011abbe0614b2490beb882598ef6d98c6e5bcd8af2fd29719d5c80fb148ce0"

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