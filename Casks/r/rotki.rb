cask "rotki" do
  arch arm: "arm64", intel: "x64"

  version "1.34.3"
  sha256 arm:   "c3a84558578ed2275f94bc633674c6186d67621f41d511dc4c3ac708a972f985",
         intel: "634ae4b4e444fabc8599875765ca8631df6f4cf450b3db3c1bc033856b65b368"

  url "https:github.comrotkirotkireleasesdownloadv#{version}rotki-darwin_#{arch}-v#{version}.dmg",
      verified: "github.comrotkirotki"
  name "Rotki"
  desc "Portfolio tracking and accounting tool"
  homepage "https:rotki.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "rotki.app"

  zap trash: [
    "~LibraryApplication Supportrotki",
    "~LibraryPreferencescom.rotki.app.plist",
    "~LibrarySaved Application Statecom.rotki.app.savedState",
  ]
end