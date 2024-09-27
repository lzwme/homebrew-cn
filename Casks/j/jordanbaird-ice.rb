cask "jordanbaird-ice" do
  version "0.11.5"
  sha256 "8b4df31e70ff66a91102f56ae874353ba45d9518e5c0dbd13efd4ae3e7f36968"

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