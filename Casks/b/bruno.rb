cask "bruno" do
  arch arm: "arm64", intel: "x64"

  version "1.12.3"
  sha256 arm:   "f9ccd4b51627f75a3a06cdfbc4ba8b38c00174fc70b384cb9ce13fd7cc26fb5d",
         intel: "3c8f70d6b7a0966313eee663ad16cb7564975627adc927722b10e7794ec5e07d"

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