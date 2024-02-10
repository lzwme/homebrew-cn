cask "tidgi" do
  arch arm: "arm64", intel: "x64"

  version "0.9.2"
  sha256 arm:   "0dfb30cadc2823a1b0eeacd07754b78cbcd6b6a374ab69d3debe9d82b5501b38",
         intel: "c1bbbbda665d5368997a5377a47d02897a39dc7b54c4f4f452cac0dc788aa00e"

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