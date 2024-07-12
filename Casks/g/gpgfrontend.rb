cask "gpgfrontend" do
  version "2.1.3"

  on_big_sur :or_older do
    sha256 "a7fa8ded6a28c31a14552b8114371c7a089aa76dc065825e3fedf1139240aa9e"

    url "https:github.comsaturnericGpgFrontendreleasesdownloadv#{version}GpgFrontend-#{version}-macos-11.dmg",
        verified: "github.comsaturnericGpgFrontend"
  end
  on_monterey :or_newer do
    sha256 "e3ef0060b1793cc1731edf96e2223aa0a35ff447aa1d590c90a81db23b14fe59"

    url "https:github.comsaturnericGpgFrontendreleasesdownloadv#{version}GpgFrontend-#{version}-macos-12.dmg",
        verified: "github.comsaturnericGpgFrontend"
  end

  name "GpgFrontend"
  desc "OpenPGPGnuPG crypto, sign and key management tool"
  homepage "https:gpgfrontend.bktus.com"

  depends_on macos: ">= :big_sur"
  depends_on formula: "gnupg"

  app "GpgFrontend.app"

  zap trash: [
    "~LibraryApplication Scriptspub.gpgfrontend.gpgfrontend",
    "~LibraryApplication SupportGpgFrontend",
    "~LibraryContainerspub.gpgfrontend.gpgfrontend",
    "~LibraryPreferencesGpgFrontend",
    "~LibraryPreferencesGpgFrontend.plist",
    "~LibraryPreferencespub.gpgfrontend.gpgfrontend.plist",
    "~LibrarySaved Application Statepub.gpgfrontend.gpgfrontend.savedState",
  ]

  caveats do
    requires_rosetta
  end
end