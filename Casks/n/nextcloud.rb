cask "nextcloud" do
  on_big_sur :or_older do
    version "3.8.1"
    sha256 "448647db0068ff9a2b669ff2f9d715a36b4e5e1af82e9849e57d9f7078d1bd2e"

    livecheck do
      skip "Legacy version"
    end

    depends_on macos: ">= :mojave"
  end
  on_monterey :or_newer do
    version "3.12.3"
    sha256 "1c020cb3163b9c1da950f8a6c4876e58f80ebdc59b07b38c742c5159d0112e06"

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
  end

  url "https:github.comnextcloud-releasesdesktopreleasesdownloadv#{version}Nextcloud-#{version}.pkg",
      verified: "github.comnextcloud-releasesdesktop"
  name "Nextcloud"
  desc "Desktop sync client for Nextcloud software products"
  homepage "https:nextcloud.com"

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