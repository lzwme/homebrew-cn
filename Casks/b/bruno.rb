cask "bruno" do
  arch arm: "arm64", intel: "x64"

  version "1.20.4"
  sha256 arm:   "9b17aa3d994d80abf4cfc97dc23a0513d2a4e4685d93a43dd230ce8801386bae",
         intel: "cbf2b14f18051b45061d20b0b4fb503f45196bbc4f9e1ee60d4a590a5bd4549e"

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