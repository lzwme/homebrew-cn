cask "blankie" do
  version "1.0.7"
  sha256 "c2cb5bcf686ada9e9d04216c7483feeeea0f16bd3a989958615f211b30fb6031"

  url "https:github.comcodybromblankiereleasesdownloadv#{version}Blankie.zip",
      verified: "github.comcodybromblankie"
  name "Blankie"
  desc "Ambient sound mixer for creating custom soundscapes"
  homepage "https:blankie.rest"

  depends_on macos: ">= :sonoma"

  app "Blankie.app"

  zap trash: [
    "~LibraryApplication SupportBlankie",
    "~LibraryCachescom.codybrom.blankie",
    "~LibraryContainerscom.codybrom.Blankie",
    "~LibraryPreferencescom.codybrom.blankie.plist",
    "~LibrarySaved Application Statecom.codybrom.blankie.savedState",
  ]
end