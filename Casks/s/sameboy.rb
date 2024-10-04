cask "sameboy" do
  version "0.16.7"
  sha256 "e9994d7b86c3847066d50a42f5476adbdc63559006d9b311a335f49c976b6eb8"

  url "https:github.comLIJI32SameBoyreleasesdownloadv#{version}sameboy_cocoa_v#{version}.zip",
      verified: "github.comLIJI32SameBoy"
  name "SameBoy"
  desc "Game Boy and Game Boy Color emulator"
  homepage "https:sameboy.github.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sierra"

  app "SameBoy.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.github.liji32.sameboy.sfl*",
    "~LibraryCachescom.github.liji32.sameboy",
    "~LibraryPreferencescom.github.liji32.sameboy.plist",
    "~LibrarySaved Application Statecom.github.liji32.sameboy.savedState",
  ]
end