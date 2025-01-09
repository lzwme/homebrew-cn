cask "bruno" do
  arch arm: "arm64", intel: "x64"

  version "1.38.1"
  sha256 arm:   "27faa96ba438d8ecabe5e7fed39d21c654137257c496a7a48585125eb33939db",
         intel: "f5f40e20b6e7b8abc67503eac02f662f24b082dd9bc392f8c84319786598ddca"

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