cask "jordanbaird-ice" do
  version "0.11.6"
  sha256 "74867a21f709c745a4b478ed421b06ce4952547042670573614235a6aaace2e1"

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