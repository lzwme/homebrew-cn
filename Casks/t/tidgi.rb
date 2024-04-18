cask "tidgi" do
  arch arm: "arm64", intel: "x64"

  version "0.9.4"
  sha256 arm:   "93808e4044ff1f7a75e8f6c15320c7e5fd052d9baf541eca92ab7cce872be27b",
         intel: "9a1e9f006a6857bb599e943a86f95236a5a0e7c25c642b1b6c11bb0a1efa61ff"

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