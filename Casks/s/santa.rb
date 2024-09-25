cask "santa" do
  version "2024.9"
  sha256 "aaffd10029040d2f12cc961504a562753ce2d135b2da4719fbba2fabb1f78e36"

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