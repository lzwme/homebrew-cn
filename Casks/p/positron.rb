cask "positron" do
  version "2024.09.0-77"
  sha256 "aeb702a822c5c7b11e99335a2b9b4fa91b5bb7eb38bcb192b1e9527bc7025b56"

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