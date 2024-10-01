cask "bruno" do
  arch arm: "arm64", intel: "x64"

  version "1.31.0"
  sha256 arm:   "67d364530737e9bdd36c4b9603d5622598881acead1a7f5f583eb39674b747b3",
         intel: "c0d13098098dc684e2250144d1577551cbf135b79633671316f6913beed1e2cd"

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