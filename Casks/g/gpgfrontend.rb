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
    version "2.1.6"
    sha256 "252a3ad9fc63de0f23ef3e781e7d56db1be5cd0dc164f9bf6c54195468314351"

    url "https:github.comsaturnericGpgFrontendreleasesdownloadv#{version}GpgFrontend-#{version}-macos-13.dmg",
        verified: "github.comsaturnericGpgFrontend"

    caveats do
      requires_rosetta
    end
  end
  on_sonoma do
    version "2.1.6"
    sha256 "6b8bab379bc7079dda7f44afe94143341212bc1086e715c763e9eb0980081ef2"

    url "https:github.comsaturnericGpgFrontendreleasesdownloadv#{version}GpgFrontend-#{version}-macos-14.dmg",
        verified: "github.comsaturnericGpgFrontend"
  end
  on_sequoia :or_newer do
    version "2.1.6"
    sha256 "8e7e577316e24174cdfccbd818fbded23c19e422fb4c84a37522eb51edc8330c"

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