cask "outset" do
  version "4.1.2.21936"
  sha256 "da11b2f8f82fc708381e573b4023a60b4d661f3de94748b8526a0c5b3aad2c3b"

  url "https:github.commacadminsoutsetreleasesdownloadv#{version}Outset-#{version}.pkg"
  name "outset"
  desc "Process packages and scripts during boot, login, or on demand"
  homepage "https:github.commacadminsoutset"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  pkg "outset-#{version}.pkg"

  uninstall launchctl: [
              "io.macadmins.Outset.boot",
              "io.macadmins.Outset.cleanup",
              "io.macadmins.Outset.login",
              "io.macadmins.Outset.login-privileged",
              "io.macadmins.Outset.login-window",
              "io.macadmins.Outset.on-demand",
            ],
            pkgutil:   "io.macadmins.Outset",
            delete:    "usrlocaloutset"

  zap trash: [
    "LibraryLaunchAgentsio.macadmins.outset.login-window.plist",
    "LibraryLaunchAgentsio.macadmins.outset.login.plist",
    "LibraryLaunchAgentsio.macadmins.outset.on-demand.plist",
    "LibraryLaunchDaemonsio.macadmins.outset.boot.plist",
    "LibraryLaunchDaemonsio.macadmins.outset.cleanup.plist",
    "LibraryLaunchDaemonsio.macadmins.outset.login-privileged.plist",
    "LibraryPreferencesio.macadmins.Outset.plist",
  ]

  caveats do
    files_in_usr_local
  end
end