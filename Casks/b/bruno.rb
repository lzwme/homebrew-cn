cask "bruno" do
  arch arm: "arm64", intel: "x64"

  version "2.6.0"
  sha256 arm:   "461484d0b3fe7d6bca7fac0bb505f86c901933d5acf4032a527d18d08e205aba",
         intel: "2bef2cb6dbdc9de3261ec242fcb8bbf960d186ad6fe517adfbbd4b06503b11d1"

  url "https:github.comusebrunobrunoreleasesdownloadv#{version}bruno_#{version}_#{arch}_mac.dmg",
      verified: "github.comusebrunobruno"
  name "Bruno"
  desc "Open source IDE for exploring and testing APIs"
  homepage "https:www.usebruno.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "Bruno.app"

  zap trash: [
    "~LibraryApplication Supportbruno",
    "~LibraryPreferencescom.usebruno.app.plist",
    "~LibrarySaved Application Statecom.usebruno.app.savedState",
  ]
end