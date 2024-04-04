cask "captain" do
  arch arm: "-arm64"

  version "10.2.1"
  sha256 arm:   "51ab7bc0f9ea512ab083a66f928807a729f17e46338388c03d16866b07351b92",
         intel: "2409daa702a396fcc62772f1cfcf4d8976f29976d29ed8b4f1f2e80c2f0aee6f"

  url "https:github.comRickWongCaptainreleasesdownloadv#{version}Captain-#{version}#{arch}.dmg",
      verified: "github.comRickWongCaptain"
  name "Captain"
  desc "Manage Docker containers from the menu bar"
  homepage "https:getcaptain.co"

  app "Captain.app"

  zap trash: [
    "~LibraryApplication Supportcaptain",
    "~LibraryPreferencescom.electron.captain.helper.plist",
    "~LibraryPreferencescom.electron.captain.plist",
    "~LibrarySaved Application Statecom.electron.captain.savedState",
  ]
end