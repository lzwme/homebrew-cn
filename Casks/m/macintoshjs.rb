cask "macintoshjs" do
  arch arm: "arm64", intel: "x64"

  version "1.2.0"
  sha256 arm:   "0df67f2a3c8398f31840c54fad030b2ff9400fb1311774771ada3d8d9990443f",
         intel: "1da79360d3c86665657692c4476343ad07b7cf3a9b2588f70833cf0f7caa4a82"

  url "https:github.comfelixriesebergmacintosh.jsreleasesdownloadv#{version}macintosh.js-darwin-#{arch}-#{version}.zip"
  name "macintosh.js"
  desc "Virtual Apple Macintosh with System 8, running in Electron"
  homepage "https:github.comfelixriesebergmacintosh.js"

  depends_on macos: ">= :high_sierra"

  app "macintosh.js.app"

  zap trash: [
    "~LibraryApplication Supportmacintosh.js",
    "~LibraryPreferencescom.felixrieseberg.macintoshjs.plist",
    "~LibrarySaved Application Statecom.felixrieseberg.macintoshjs.savedState",
    "~macintosh.js",
  ]
end