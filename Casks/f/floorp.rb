cask "floorp" do
  version "11.25.0"
  sha256 "76225e9b2e13e72f7ad82b420eb6a7d0e0553b2341d32a68c89e4fadf7f273ab"

  url "https:github.comFloorp-ProjectsFloorpreleasesdownloadv#{version}floorp-macOS-universal.dmg",
      verified: "github.comFloorp-ProjectsFloorp"
  name "Floorp browser"
  desc "Privacy-focused Firefox-based browser"
  homepage "https:floorp.app"

  livecheck do
    url "https:floorp.appendownload"
    regex(%r{v?(\d+(?:\.\d+)+)floorp[._-]macOS[._-]universal\.dmg}i)
  end

  auto_updates true
  depends_on macos: ">= :catalina"

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