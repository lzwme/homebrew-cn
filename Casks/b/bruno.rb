cask "bruno" do
  arch arm: "arm64", intel: "x64"

  version "1.36.1"
  sha256 arm:   "d6bdc16c4aca8a374c3545d7045b766a145f4627fe7be0d8c5a25444ce6f8d81",
         intel: "78d80a8e2a041fefbb5ce8d34c0f89b88605cc0cc60451cc867f4e27fe7b38b2"

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