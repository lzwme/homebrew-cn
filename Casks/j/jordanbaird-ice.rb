cask "jordanbaird-ice" do
  version "0.9.0"
  sha256 "32f90944ff12b73f5520adef06759ecd52aad8a90f7d46bf35407126d6331e15"

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