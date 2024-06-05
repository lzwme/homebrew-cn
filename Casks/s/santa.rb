cask "santa" do
  version "2024.5"
  sha256 "cf8b1855e6a8ded93f6ea8c924c40b867229d4c5bb4cdc5820ee9db43b96f1e8"

  url "https:github.comgooglesantareleasesdownload#{version}santa-#{version}.dmg"
  name "Santa"
  desc "Binary authorization system"
  homepage "https:github.comgooglesanta"

  livecheck do
    url :url
    strategy :github_latest
  end

  pkg "santa-#{version}.pkg"

  uninstall launchctl: [
              "com.google.santa",
              "com.google.santa.bundleservice",
              "com.google.santa.metricservice",
              "com.google.santa.syncservice",
              "com.google.santad",
            ],
            kext:      "com.google.santa-driver",
            pkgutil:   "com.google.santa",
            delete:    [
              "ApplicationsSanta.app",
              "usrlocalbinsantactl",
            ]

  # No zap stanza required

  caveats "For #{token} to use EndpointSecurity, it must be granted Full Disk Access under " \
          "System Preferences → Security & Privacy → Privacy"
end