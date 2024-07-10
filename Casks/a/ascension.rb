cask "ascension" do
  version "3.0.0"
  sha256 "b21598b455878b997a08c88ef1c800eef2ad648ca672228db90ece0754d5e492"

  url "https:github.comansiloveAscensionreleasesdownloadv#{version}Ascension_v#{version}.zip"
  name "Ascension"
  desc "ANSIASCII art viewer"
  homepage "https:github.comansiloveAscension"

  app "Ascension.app"

  zap trash: [
    "~LibraryApplication SupportAscension",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.byteproject.ascension.sfl*",
    "~LibraryPreferencescom.byteproject.Ascension.plist",
    "~LibrarySaved Application Statecom.byteproject.Ascension.savedState",
  ]

  caveats do
    requires_rosetta
  end
end