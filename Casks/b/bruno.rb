cask "bruno" do
  arch arm: "arm64", intel: "x64"

  version "1.33.1"
  sha256 arm:   "e63c23d15593bdb658228c2809e80b3cb9b6df192d1322d16e24f4b2a5676c45",
         intel: "7bfb2f34dcb93d69f1f9de219b373455389907d10cdcb6201234fae8278487de"

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