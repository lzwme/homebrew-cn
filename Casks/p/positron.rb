cask "positron" do
  version "2024.07.0-85"
  sha256 "ec00cfee0ac97461691610c94f8402ec122e8ba216294825e7a11705b87a009f"

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