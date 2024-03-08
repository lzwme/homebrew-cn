cask "jordanbaird-ice" do
  version "0.6.3"
  sha256 "19c5b2edfb447d960ebcae6dd88eeb7e14915e67fc9daf18a87d29811980120e"

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