cask "bruno" do
  arch arm: "arm64", intel: "x64"

  version "2.0.1"
  sha256 arm:   "aec3e427fcc62e4c3f7c78e02b3c7e091e0bd8e0b7754619c44c7ac3722103ac",
         intel: "807b04b4f308f6ec3d38b91283cae2eb6d7c2d8808a34daebbadbfae638430ca"

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