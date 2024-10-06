cask "jordanbaird-ice" do
  version "0.11.8.1"
  sha256 "5d7b9b73e06eb7031f83d8bbb32c8e76a5e6986fe58795a6067b5c9bd4b236d3"

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