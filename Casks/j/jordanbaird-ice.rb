cask "jordanbaird-ice" do
  version "0.10.2"
  sha256 "fed3faadf9ea8e9e2b8a90a0401dc4987e3f9a32873fa0a58ff045e12de97fe5"

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