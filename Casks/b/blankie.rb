cask "blankie" do
  version "1.0.12"
  sha256 "e32128be52852db69b01ce5b489a2d87f771e375f0feb9cc8d9393a5a6179a89"

  url "https:github.comcodybromblankiereleasesdownloadv#{version}Blankie.zip",
      verified: "github.comcodybromblankie"
  name "Blankie"
  desc "Ambient sound mixer for creating custom soundscapes"
  homepage "https:blankie.rest"

  no_autobump! because: :bumped_by_upstream

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