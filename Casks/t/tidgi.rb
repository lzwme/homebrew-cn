cask "tidgi" do
  arch arm: "arm64", intel: "x64"

  version "0.9.3"
  sha256 arm:   "06aacae2c24c1b7d0e68a08109414f0e932d3da96d00c6134f7a264e3de2bce8",
         intel: "4019333b330e3666322f4b154c52e57131239051bc6af82f96b54edde49e42a5"

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