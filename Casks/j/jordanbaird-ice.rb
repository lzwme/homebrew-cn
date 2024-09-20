cask "jordanbaird-ice" do
  version "0.11.3"
  sha256 "b5caf5eda892449a05cc2d048c2f6a4955cbd57ea0ebdf3748cbd89bd298a055"

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