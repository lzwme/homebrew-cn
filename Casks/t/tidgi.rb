cask "tidgi" do
  arch arm: "arm64", intel: "x64"

  version "0.9.0"
  sha256 arm:   "387babbdb122d4557f30f618af56431f848ce615a3d183f0cc82786747fb46be",
         intel: "53a7c428f67cebef44f93e7ffb98193b57bf6d60ba370eb5d8518f7b8089b75a"

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
    "~LibraryCachescom.tidgi.app.ShipIt",
    "~LibraryCachescom.tidgi.app",
    "~LibraryPreferencescom.tidgi.app.plist",
    "~LibraryPreferencescom.tidgi.plist",
    "~LibrarySaved Application Statecom.microsoft.VSCode.savedState",
  ]
end