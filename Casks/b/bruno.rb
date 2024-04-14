cask "bruno" do
  arch arm: "arm64", intel: "x64"

  version "1.13.0"
  sha256 arm:   "2dee5782c1898c4db383629c968403fbd5eb6ab4a9e64b134f111deb2efdc74c",
         intel: "abc7d5bac3727da878244fb396333d086a6713cbfe886c42cb205854a2957110"

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