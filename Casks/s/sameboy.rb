cask "sameboy" do
  version "0.16"
  sha256 "3d0669f7d56356d21f2fc5f748e5b8ffb2e5052f295930372d94d9926da53c98"

  url "https:github.comLIJI32SameBoyreleasesdownloadv#{version}sameboy_cocoa_v#{version}.zip",
      verified: "github.comLIJI32SameBoy"
  name "SameBoy"
  desc "Game Boy and Game Boy Color emulator written in C"
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