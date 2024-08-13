cask "gpgfrontend" do
  version "2.1.4"

  on_monterey :or_older do
    sha256 "073f03f13858883451e597b29701dae3b24e3b3b5d96f36b8ee0ce398a60db2f"

    url "https:github.comsaturnericGpgFrontendreleasesdownloadv#{version}GpgFrontend-#{version}-macos-12.dmg",
        verified: "github.comsaturnericGpgFrontend"

    caveats do
      requires_rosetta
    end
  end
  on_ventura do
    sha256 "47a27d10c1fc9cc73ab3ee3a1b34317a0f8900423836b28a876ad207cb696bf0"

    url "https:github.comsaturnericGpgFrontendreleasesdownloadv#{version}GpgFrontend-#{version}-macos-13.dmg",
        verified: "github.comsaturnericGpgFrontend"

    caveats do
      requires_rosetta
    end
  end
  on_sonoma :or_newer do
    sha256 "791069c821a6ab9405244b6156eba9a6d6a77a4de1752a69466aa9fd1d0183a3"

    url "https:github.comsaturnericGpgFrontendreleasesdownloadv#{version}GpgFrontend-#{version}-macos-14.dmg",
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