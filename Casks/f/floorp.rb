cask "floorp" do
  version "11.7.0"
  sha256 "28841166f46d88a8778054dbbd7b58fa31ccedc3cd9e09a1e38e31b14dd111a9"

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