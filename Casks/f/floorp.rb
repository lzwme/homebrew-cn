cask "floorp" do
  version "11.8.2"
  sha256 "a62cb45fae75976166c9ead8282d520d305d1c0386614f8b88a39efb33e8250c"

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