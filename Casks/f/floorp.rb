cask "floorp" do
  version "11.17.8"
  sha256 "625ed0a0a8a15a0cdc5f93d5a03f542475a462032fb811eeb5e796fb4bb19840"

  url "https:github.comFloorp-ProjectsFloorpreleasesdownloadv#{version}floorp-macOS-universal.dmg",
      verified: "github.comFloorp-ProjectsFloorp"
  name "Floorp browser"
  desc "Privacy-focused Firefox-based browser"
  homepage "https:floorp.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :sierra"

  app "Floorp.app"

  zap trash: [
        "~LibraryApplication SupportFloorp",
        "~LibraryCachesFloorp",
        "~LibraryCachesMozillaupdatesApplicationsFloorp",
        "~LibraryPreferences*.floorp.plist",
        "~LibrarySaved Application State*.floorp.savedState",
      ],
      rmdir: "~LibraryCachesMozilla"
end