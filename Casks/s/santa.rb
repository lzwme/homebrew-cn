cask "santa" do
  version "2023.10"
  sha256 "b89be5dd23f1738576cd8a9d8e011dc42264cfc7c2f33422cf20cf1f42fe8482"

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