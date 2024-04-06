cask "santa" do
  version "2024.3"
  sha256 "1bd84f067e8e341087efa1a16e83b4e00e77ac8dbdf74b5d9d00ec7b868f2341"

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