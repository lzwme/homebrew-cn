cask "rotki" do
  arch arm: "arm64", intel: "x64"

  version "1.38.0"
  sha256 arm:   "aca4030b20cb7b12228bb1ea137d6be672592d698ee5e79415918fb18d42c6e6",
         intel: "e4e024691ec2d0b9dc6e1701be6cb214486fb0deca692cc3333e66711d244a3a"

  url "https:github.comrotkirotkireleasesdownloadv#{version}rotki-darwin_#{arch}-v#{version}.dmg",
      verified: "github.comrotkirotki"
  name "Rotki"
  desc "Portfolio tracking and accounting tool"
  homepage "https:rotki.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "rotki.app"

  zap trash: [
    "~LibraryApplication Supportrotki",
    "~LibraryPreferencescom.rotki.app.plist",
    "~LibrarySaved Application Statecom.rotki.app.savedState",
  ]
end