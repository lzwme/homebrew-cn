cask "rotki" do
  arch arm: "arm64", intel: "x64"

  version "1.38.1"
  sha256 arm:   "dc3951fdd56fd134346ec70c6d93c322f6b1c8b30483e71a25dfd92bd4e113f3",
         intel: "c654c13fc1a2abb7b55f01608869d25c583cde9b3445b8eae2f1e8f1f680337f"

  url "https:github.comrotkirotkireleasesdownloadv#{version}rotki-darwin_#{arch}-v#{version}.dmg",
      verified: "github.comrotkirotki"
  name "Rotki"
  desc "Portfolio tracking and accounting tool"
  homepage "https:rotki.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "rotki.app"

  zap trash: [
    "~LibraryApplication Supportrotki",
    "~LibraryPreferencescom.rotki.app.plist",
    "~LibrarySaved Application Statecom.rotki.app.savedState",
  ]
end