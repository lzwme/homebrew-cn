cask "bruno" do
  arch arm: "arm64", intel: "x64"

  version "1.27.0"
  sha256 arm:   "a986a98939e8727f01ce08d888767ea301e7aa49213fb428625348657306615a",
         intel: "945995e4e1ccfcddd2e51f4402d477e538c0088e7c870676f11b14bcca19b04a"

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