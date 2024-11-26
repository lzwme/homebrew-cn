cask "tidgi" do
  arch arm: "arm64", intel: "x64"

  version "0.11.1"
  sha256 arm:   "299752879cc73039b64bb9299d6c0dfb353c55e9710b65eace2e5bea3d32c3bf",
         intel: "ef59f45c532596cf2ced091105fa7c3a7cdf45d8760d37ca64a817e64023e99f"

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