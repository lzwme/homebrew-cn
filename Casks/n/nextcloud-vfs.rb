cask "nextcloud-vfs" do
  version "3.15.3"
  sha256 "f2ca9a7acd71415668f62e5d73d20af2c3bb239104889da497632c8a487b9ce1"

  url "https:github.comnextcloud-releasesdesktopreleasesdownloadv#{version}Nextcloud-#{version}-macOS-vfs.pkg",
      verified: "github.comnextcloud-releasesdesktop"
  name "Nextcloud Virtual Files"
  desc "Desktop sync client for Nextcloud software products"
  homepage "https:nextcloud.com"

  # Upstream publishes releases for multiple different minor versions and the
  # "latest" release is sometimes a lower version. Until the "latest" release
  # is reliably the highest version, we have to check multiple releases.
  livecheck do
    url :url
    regex(^Nextcloud[._-]v?(\d+(?:\.\d+)+)[._-]macOS[._-]vfs\.pkg$i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]

        release["assets"]&.map do |asset|
          match = asset["name"]&.match(regex)
          next if match.blank?

          match[1]
        end
      end.flatten
    end
  end

  auto_updates true
  conflicts_with cask: "nextcloud"
  depends_on macos: ">= :monterey"

  pkg "Nextcloud-#{version}-macOS-vfs.pkg"
  binary "ApplicationsNextcloud.appContentsMacOSnextcloudcmd"

  uninstall launchctl: "com.nextcloud.desktopclient",
            quit:      "com.nextcloud.desktopclient",
            pkgutil:   "com.nextcloud.desktopclient",
            delete:    "ApplicationsNextcloud.app"

  zap trash: [
    "~LibraryApplication Scriptscom.nextcloud.desktopclient.FileProviderExt",
    "~LibraryApplication Scriptscom.nextcloud.desktopclient.FileProviderUIExt",
    "~LibraryApplication Scriptscom.nextcloud.desktopclient.FinderSyncExt",
    "~LibraryApplication SupportNextcloud",
    "~LibraryCachesNextcloud",
    "~LibraryContainersNextcloud Extensions",
    "~LibraryContainersNextcloud File Provider Extension",
    "~LibraryContainersNextcloud File Provider UI Extension",
    "~LibraryGroup Containerscom.nextcloud.desktopclient",
    "~LibraryHTTPStoragescom.nextcloud.desktopclient",
    "~LibraryLaunchAgentscom.nextcloud.desktopclient.plist",
    "~LibraryPreferencescom.nextcloud.desktopclient",
    "~LibraryPreferencescom.nextcloud.desktopclient.plist",
    "~LibraryPreferencesNextcloud",
  ]
end