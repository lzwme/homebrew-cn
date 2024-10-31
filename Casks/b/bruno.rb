cask "bruno" do
  arch arm: "arm64", intel: "x64"

  version "1.34.1"
  sha256 arm:   "9c33a2bdd8ca2c95edd2352c85f7baa113053ed333d427b862a18088839cb497",
         intel: "217b2c794222ca82a653664e199f812925d64bee50f92ee786e9397a9e5611c7"

  url "https:github.comusebrunobrunoreleasesdownloadv#{version}bruno_#{version}_#{arch}_mac.dmg",
      verified: "github.comusebrunobruno"
  name "Bruno"
  desc "Opensource IDE for exploring and testing api's"
  homepage "https:www.usebruno.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "Bruno.app"

  zap trash: [
    "~LibraryApplication Supportbruno",
    "~LibraryPreferencescom.usebruno.app.plist",
    "~LibrarySaved Application Statecom.usebruno.app.savedState",
  ]
end