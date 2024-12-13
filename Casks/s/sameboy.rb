cask "sameboy" do
  version "1.0"
  sha256 "6200ba47f17a856832ebb9f3ede8c7f7b7a4d5f6b5599c21b6a7b3bfe875bd14"

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