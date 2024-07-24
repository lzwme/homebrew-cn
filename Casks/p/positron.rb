cask "positron" do
  version "2024.07.0-89"
  sha256 "76409db56b008a959cb51dab780ccc846d82b847d626af3f4a8199bfd3687a1f"

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