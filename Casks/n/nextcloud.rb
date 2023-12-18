cask "nextcloud" do
  on_el_capitan :or_older do
    version "2.6.5.20200710-legacy"
    sha256 "4c67e50361dd5596fb884002d1ed907fe109d607fba2cabe07e505addd164519"

    url "https:github.comnextclouddesktopreleasesdownloadv#{version.major_minor_patch}Nextcloud-#{version}.pkg",
        verified: "github.comnextclouddesktop"
  end
  on_sierra :or_newer do
    version "3.11.0"
    sha256 "e2e42c4d255546e32d11e3c2c20d8e805aa08425d6f7994f0a1fa3c3438047b3"

    url "https:github.comnextcloud-releasesdesktopreleasesdownloadv#{version}Nextcloud-#{version}.pkg",
        verified: "github.comnextcloud-releasesdesktop"
  end

  name "Nextcloud"
  desc "Desktop sync client for Nextcloud software products"
  homepage "https:nextcloud.com"

  livecheck do
    url :url
    regex(^Nextcloud[._-]v?(\d+(?:\.\d+)+)\.pkg$i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  auto_updates true

  pkg "Nextcloud-#{version}.pkg"
  binary "ApplicationsNextcloud.appContentsMacOSnextcloudcmd"

  uninstall quit:    "com.nextcloud.desktopclient",
            pkgutil: "com.nextcloud.desktopclient",
            delete:  "ApplicationsNextcloud.app"

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