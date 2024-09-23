cask "bruno" do
  arch arm: "arm64", intel: "x64"

  version "1.30.1"
  sha256 arm:   "8a060dca6d6472e5ca223d0281af4315cfdcf5cedda60625415d1d1db93791c4",
         intel: "302e7a5631f69130f692db8bef4046c3d63a9ab335bf76faa0bea40b8a877bcf"

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