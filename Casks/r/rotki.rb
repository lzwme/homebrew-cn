cask "rotki" do
  arch arm: "arm64", intel: "x64"

  version "1.34.2"
  sha256 arm:   "3c062c7fa467f6b78d6a6748fe2a7f806fffbfad6bbeb56bdfb79d1d9adbde0a",
         intel: "fad4e670a3ec1f252bef85fcd64209043869f2a0e6607d843170bcd0c573134c"

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