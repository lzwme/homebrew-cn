cask "nextcloud" do
  on_big_sur :or_older do
    version "3.8.1"
    sha256 "448647db0068ff9a2b669ff2f9d715a36b4e5e1af82e9849e57d9f7078d1bd2e"

    livecheck do
      skip "Legacy version"
    end
  end
  on_monterey :or_newer do
    version "3.14.0"
    sha256 "b173b2b8cca1e4a11378d70b8cb46bbe67aa244f3e23b215a0c87c50e8cb4fe9"

    # Upstream publishes releases for multiple different minor versions and the
    # "latest" release is sometimes a lower version. Until the "latest" release
    # is reliably the highest version, we have to check multiple releases.
    livecheck do
      url :url
      regex(^Nextcloud[._-]v?(\d+(?:\.\d+)+)\.pkg$i)
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
  end

  url "https:github.comnextcloud-releasesdesktopreleasesdownloadv#{version}Nextcloud-#{version}.pkg",
      verified: "github.comnextcloud-releasesdesktop"
  name "Nextcloud"
  desc "Desktop sync client for Nextcloud software products"
  homepage "https:nextcloud.com"

  auto_updates true
  conflicts_with cask: "nextcloud-vfs"
  depends_on macos: ">= :mojave"

  pkg "Nextcloud-#{version}.pkg"
  binary "ApplicationsNextcloud.appContentsMacOSnextcloudcmd"

  uninstall launchctl: "com.nextcloud.desktopclient",
            quit:      "com.nextcloud.desktopclient",
            pkgutil:   "com.nextcloud.desktopclient",
            delete:    "ApplicationsNextcloud.app"

  zap trash: [
    "~LibraryApplication Scriptscom.nextcloud.desktopclient.FinderSyncExt",
    "~LibraryApplication SupportNextcloud",
    "~LibraryCachesNextcloud",
    "~LibraryContainerscom.nextcloud.desktopclient.FinderSyncExt",
    "~LibraryGroup Containerscom.nextcloud.desktopclient",
    "~LibraryPreferencescom.nextcloud.desktopclient.plist",
    "~LibraryPreferencesNextcloud",
  ]
end