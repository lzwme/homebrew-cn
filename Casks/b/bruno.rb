cask "bruno" do
  arch arm: "arm64", intel: "x64"

  version "1.6.0"
  sha256 arm:   "5520c17bf076ac71fc3df4413f0d226e2cca0f77b7b23cfe64226f3731b1ad1e",
         intel: "91006658ff91d697d6e95ac4aaf9c1c7437cb7095ccf71cedf4bef48c0909bd5"

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