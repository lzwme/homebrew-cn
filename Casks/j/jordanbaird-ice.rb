cask "jordanbaird-ice" do
  version "0.10.5"
  sha256 "97b5c3061dd381feb6ada0acf380805547cd5d188843f4f7bf0a9fd38576e36c"

  url "https:github.comjordanbairdIcereleasesdownload#{version}Ice.zip",
      verified: "github.comjordanbairdIce"
  name "Ice"
  desc "Menu bar manager"
  homepage "https:icemenubar.app"

  auto_updates true
  depends_on macos: ">= :sonoma"

  app "Ice.app"

  uninstall quit: "com.jordanbaird.Ice"

  zap trash: "~LibraryPreferencescom.jordanbaird.Ice.plist"
end