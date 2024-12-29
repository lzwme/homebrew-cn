cask "pliim" do
  version "1.7.0"
  sha256 "cd44a3e8d0d58b431df288c3ce13a8032f76b270077ac488cb9db5d74e7d17a5"

  url "https:github.comzehfernandespliimreleasesdownloadv#{version}Pliim.app.zip",
      verified: "github.comzehfernandespliim"
  name "Pliim"
  desc "One click and be ready to go up on stage and shine!"
  homepage "https:zehfernandes.github.iopliim"

  app "Pliim.app"

  zap trash: [
    "~LibraryApplication SupportPliim",
    "~LibraryLogsPliim",
    "~LibraryPreferencescom.electron.pliim.plist",
    "~LibrarySaved Application Statecom.electron.pliim.savedState",
  ]

  caveats do
    requires_rosetta
  end
end