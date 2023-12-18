cask "autumn" do
  version "1.0.7"
  sha256 "2f6bff1c6203eddc8c3d48887d176d5dec0bc57dc66c3dfa1740c5a0dcd6fe93"

  url "https:github.comapandhiAutumnreleasesdownload#{version}Build.zip",
      verified: "github.comapandhiAutumn"
  name "Autumn"
  desc "Window manager for JavaScript development"
  homepage "https:apandhi.github.ioAutumn"

  depends_on macos: ">= :high_sierra"

  app "Autumn.app"

  zap trash: [
    "~LibraryCachescom.sephware.autumn",
    "~LibraryPreferencescom.sephware.autumn.plist",
    "~LibraryWebKitcom.sephware.autumn",
  ]
end