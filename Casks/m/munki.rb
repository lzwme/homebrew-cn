cask "munki" do
  version "6.6.1.4696"
  sha256 "1e6a343684f80f3d3247266a90918b26331474bbd1065a0e5bb4b79d2dbd07c6"

  url "https:github.communkimunkireleasesdownloadv#{version.major_minor_patch}munkitools-#{version}.pkg",
      verified: "github.communkimunki"
  name "Munki"
  desc "Software installation manager"
  homepage "https:www.munki.orgmunki"

  livecheck do
    url :url
    regex(^munkitools[._-]v?(\d+(?:\.\d+)+)\.pkg$i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  pkg "munkitools-#{version}.pkg"

  uninstall launchctl: [
              "com.googlecode.munki.app_usage_monitor",
              "com.googlecode.munki.appusaged",
              "com.googlecode.munki.authrestartd",
              "com.googlecode.munki.logouthelper",
              "com.googlecode.munki.ManagedSoftwareCenter",
              "com.googlecode.munki.managedsoftwareupdate-check",
              "com.googlecode.munki.managedsoftwareupdate-install",
              "com.googlecode.munki.managedsoftwareupdate-manualcheck",
              "com.googlecode.munki.munki-notifier",
            ],
            pkgutil:   "com.googlecode.munki.*",
            delete:    "usrlocalmunki"

  zap trash: [
    "LibraryLaunchDaemonscom.googlecode.munki.appusaged.plist",
    "LibraryLaunchDaemonscom.googlecode.munki.authrestartd.plist",
    "LibraryLaunchDaemonscom.googlecode.munki.logouthelper.plist",
    "LibraryLaunchDaemonscom.googlecode.munki.managedsoftwareupdate-check.plist",
    "LibraryLaunchDaemonscom.googlecode.munki.managedsoftwareupdate-install.plist",
    "LibraryLaunchDaemonscom.googlecode.munki.managedsoftwareupdate-manualcheck.plist",
  ]
end