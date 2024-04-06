cask "jordanbaird-ice" do
  version "0.8.0"
  sha256 "44e27ccea96dd311c1744b399f6e0b19799665b43aaab38bd3d8715ac84b7713"

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