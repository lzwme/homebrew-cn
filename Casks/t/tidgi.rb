cask "tidgi" do
  arch arm: "arm64", intel: "x64"

  version "0.9.6"
  sha256 arm:   "d59f65c59656ad455012104efcab76012fee36cd977e285d2f4886ae0b8f4398",
         intel: "e631d6fd0ae0cec1907d7e0bbec45e6dd3893f3613be1b42e66733c69db03c8f"

  url "https:github.comtiddly-gittlyTidGi-Desktopreleasesdownloadv#{version}TidGi-darwin-#{arch}-#{version}.zip"
  name "TidGi"
  desc "Personal knowledge-base app"
  homepage "https:github.comtiddly-gittlyTidGi-Desktop"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "TidGi.app"

  zap trash: [
    "~LibraryApplication SupportTidGi",
    "~LibraryCachescom.tidgi.app",
    "~LibraryCachescom.tidgi.app.ShipIt",
    "~LibraryPreferencescom.tidgi.app.plist",
    "~LibraryPreferencescom.tidgi.plist",
    "~LibrarySaved Application Statecom.microsoft.VSCode.savedState",
  ]
end