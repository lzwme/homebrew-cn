cask "bruno" do
  arch arm: "arm64", intel: "x64"

  version "1.37.0"
  sha256 arm:   "b5a693baaf30bf8fcabf67755a7db63fb14c2aea9d2554a00eaee29d4bd16ac7",
         intel: "0ca652b99081a1a16bf6e64b0005e28422eb24dab4639635b62be202d32ab230"

  url "https:github.comusebrunobrunoreleasesdownloadv#{version}bruno_#{version}_#{arch}_mac.dmg",
      verified: "github.comusebrunobruno"
  name "Bruno"
  desc "Opensource IDE for exploring and testing api's"
  homepage "https:www.usebruno.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "Bruno.app"

  zap trash: [
    "~LibraryApplication Supportbruno",
    "~LibraryPreferencescom.usebruno.app.plist",
    "~LibrarySaved Application Statecom.usebruno.app.savedState",
  ]
end