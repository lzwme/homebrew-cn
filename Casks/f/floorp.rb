cask "floorp" do
  version "11.11.2"
  sha256 "24f058e1cc2cf2b27aa6ac675bb4422969645be1415804742544fd72afc65416"

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