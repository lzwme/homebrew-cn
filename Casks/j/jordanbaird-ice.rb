cask "jordanbaird-ice" do
  version "0.7.1"
  sha256 "59293feb4111524b1ddab1b298174c66bb7ddba9d784454d6843f3f81fbd1d4d"

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