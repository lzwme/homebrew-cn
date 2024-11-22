cask "bruno" do
  arch arm: "arm64", intel: "x64"

  version "1.35.0"
  sha256 arm:   "b631521d63f980fd9ae442c8b06f1d3695268c4bd64982f07bd48dd3b6d9b86f",
         intel: "a73f762c21c3537d6e63ea21b3efe6b1e36fbe272077a63bea13f984ff7fe10d"

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