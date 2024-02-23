cask "jordanbaird-ice" do
  version "0.5.0"
  sha256 "f9c22913aab605e4e378a7e784261466cb3f9bcf45862796b6a26c58d05a2df7"

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