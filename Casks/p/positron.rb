cask "positron" do
  version "2024.12.0-41"
  sha256 "5d2a74a62a336bf73fb2188522b6be990d711d8ad4c99d70b0f30fcac58e2691"

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