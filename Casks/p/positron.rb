cask "positron" do
  version "2024.07.0-49"
  sha256 "471ef0fc5cd22afab5933ff1fee85550523c632a06e721aa5f081c617ccf53f8"

  url "https:github.composit-devpositronreleasesdownload#{version}Positron-#{version}.dmg"
  name "Positron"
  desc "Data science IDE"
  homepage "https:github.composit-devpositron"

  depends_on macos: ">= :catalina"

  app "Positron.app"

  zap trash: [
    "~.positron",
    "~LibraryApplication SupportPositron",
    "~LibraryPreferencescom.rstudio.positron.plist",
    "~LibrarySaved Application Statecom.rstudio.positron.savedState",
  ]
end