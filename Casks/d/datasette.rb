cask "datasette" do
  version "0.2.3"
  sha256 "a708f435afebf5c95d7ea4026699b6b64db6b7e08f9581dd5a143109a5cb986d"

  url "https:github.comsimonwdatasette-appreleasesdownload#{version}Datasette.app.zip",
      verified: "github.comsimonwdatasette-app"
  name "Datasette"
  desc "Desktop application that wraps Datasette"
  homepage "https:datasette.iodesktop"

  depends_on macos: ">= :high_sierra"

  app "Datasette.app"

  zap trash: [
    "~LibraryApplication SupportDatasette",
    "~LibraryCachesio.datasette.app.ShipIt",
    "~LibraryPreferencesio.datasette.app.plist",
    "~LibrarySaved Application Stateio.datasette.app.savedState",
  ]
end