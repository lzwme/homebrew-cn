cask "gather" do
  arch arm: "-arm64"

  version "1.5.2"
  sha256 arm:   "33cb944cbcf91fa5bca1b5cad72a1fd2072d807b801c523778280575ce514a7f",
         intel: "a44003d9a9269702248da2672b83a93a69386b99beb77408bb43673f831100e5"

  url "https:github.comgathertowngather-town-desktop-releasesreleasesdownloadv#{version}Gather-#{version}#{arch}-mac.zip",
      verified: "github.comgathertowngather-town-desktop-releases"
  name "Gather Town"
  desc "Virtual video-calling space"
  homepage "https:gather.town"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "Gather.app"

  zap trash: [
    "~LibraryApplication SupportGather",
    "~LibraryLogsGather",
    "~LibraryPreferencescom.gather.Gather.plist",
    "~LibrarySaved Application Statecom.gather.Gather.savedState",
  ]
end