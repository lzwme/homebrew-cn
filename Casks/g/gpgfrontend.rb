cask "gpgfrontend" do
  on_monterey :or_older do
    version "2.1.5"
    sha256 "731acf48fea4fed6fc4a0065b8e50655e8cff911c62e31f1fc5f4b8c2b478db2"

    url "https:github.comsaturnericGpgFrontendreleasesdownloadv#{version}GpgFrontend-#{version}-macos-12.dmg",
        verified: "github.comsaturnericGpgFrontend"

    livecheck do
      skip "Legacy version"
    end

    caveats do
      requires_rosetta
    end
  end
  on_ventura do
    version "2.1.7"
    sha256 "e7492fcaf2522992f1a4a2f62656f22b64403f56325f11a975c5d875c54c3558"

    url "https:github.comsaturnericGpgFrontendreleasesdownloadv#{version}GpgFrontend-#{version}-macos-13.dmg",
        verified: "github.comsaturnericGpgFrontend"

    caveats do
      requires_rosetta
    end
  end
  on_sonoma do
    version "2.1.7"
    sha256 "943131ceb28696764d4dc215f5b841fe340b9071857afa06503630199eec01e3"

    url "https:github.comsaturnericGpgFrontendreleasesdownloadv#{version}GpgFrontend-#{version}-macos-14.dmg",
        verified: "github.comsaturnericGpgFrontend"
  end
  on_sequoia :or_newer do
    version "2.1.7"
    sha256 "ca5f7e885b8e214aa9c325e07654fe0cc281744ff587f21227caa9eda8196c00"

    url "https:github.comsaturnericGpgFrontendreleasesdownloadv#{version}GpgFrontend-#{version}-macos-15.dmg",
        verified: "github.comsaturnericGpgFrontend"
  end

  name "GpgFrontend"
  desc "OpenPGPGnuPG crypto, sign and key management tool"
  homepage "https:gpgfrontend.bktus.com"

  depends_on macos: ">= :monterey"
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
end