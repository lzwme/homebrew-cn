cask "ubports-installer" do
  version "0.10.0"
  sha256 "1a9e1bb64c8a714e239a985a521e7ca38b46a77bfc3c80adbf938e3078d51c2f"

  url "https:github.comubportsubports-installerreleasesdownload#{version}ubports-installer_#{version}_mac_x64.dmg",
      verified: "github.comubportsubports-installer"
  name "ubports installer"
  desc "Application to install ubports on mobile devices"
  homepage "https:ubports.com"

  livecheck do
    url :url
    regex(v?(\d+(?:\.\d+)+(?:-beta)?)i)
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "ubports-installer.app"

  zap trash: [
    "~LibraryApplication Supportubports-installer",
    "~LibraryPreferencescom.ubports.installer.plist",
    "~LibrarySaved Application Statecom.ubports.installer.savedState",
  ]

  caveats do
    requires_rosetta
  end
end