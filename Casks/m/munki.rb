cask "munki" do
  version "6.6.5.4711"
  sha256 "8cf51c439401c72ae4a79919652b811559be27947015ff5c116fe2fb1c113697"

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