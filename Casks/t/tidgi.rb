cask "tidgi" do
  arch arm: "arm64", intel: "x64"

  version "0.10.2"
  sha256 arm:   "bdd1e1a04aa87849e1436e94a41571080d1d8ec546a247fc9e6421f7bae20c76",
         intel: "c8db997db9f8cc0ec91b993bfe312b7be22a853db9f19d5a61663360ec6ea278"

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