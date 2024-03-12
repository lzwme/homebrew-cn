cask "jordanbaird-ice" do
  version "0.7.0"
  sha256 "e903db13117a631aba3abc5b5b0b5eec4b35e39da196ef651e29d3db42537adb"

  url "https:github.comjordanbairdIcereleasesdownload#{version}Ice.zip"
  name "Ice"
  desc "Menu bar manager"
  homepage "https:github.comjordanbairdIce"

  auto_updates true
  depends_on macos: ">= :sonoma"

  app "Ice.app"

  uninstall quit: "com.jordanbaird.Ice"

  zap trash: "~LibraryPreferencescom.jordanbaird.Ice.plist"
end