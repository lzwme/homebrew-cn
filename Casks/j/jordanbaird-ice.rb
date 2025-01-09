cask "jordanbaird-ice" do
  version "0.11.12"
  sha256 "d770e81597566dd2d2363feb350f808c7a92e363df95c51e48140eb30e452cc9"

  url "https:github.comjordanbairdice-releasesreleasesdownload#{version}Ice.zip",
      verified: "github.comjordanbairdice-releases"
  name "Ice"
  desc "Menu bar manager"
  homepage "https:icemenubar.app"

  livecheck do
    url "https:jordanbaird.github.ioice-releasesappcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :sonoma"

  app "Ice.app"

  uninstall quit:       "com.jordanbaird.Ice",
            login_item: "Ice"

  zap trash: [
    "~LibraryCachescom.jordanbaird.Ice",
    "~LibraryHTTPStoragescom.jordanbaird.Ice",
    "~LibraryPreferencescom.jordanbaird.Ice.plist",
    "~LibraryWebKitcom.jordanbaird.Ice",
  ]
end