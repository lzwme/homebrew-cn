cask "lantern" do
  version "7.7.0"
  sha256 :no_check

  url "https:s3.amazonaws.comlanternlantern-installer.dmg",
      verified: "s3.amazonaws.comlantern"
  name "Lantern"
  desc "Open Internet For All"
  homepage "https:lantern.io"

  # The first-party download page (https:lantern.iodownload?os=mac) only
  # links to an unversioned file, with no version information on the page. We
  # check GitHub releases as a best guess of when a new version is released.
  # Upstream has not marked recent releases as "latest", so we have to check
  # multiple releases until upstream reliably marks releases as "latest" again.
  livecheck do
    url "https:github.comgetlanternlantern"
    strategy :github_releases
  end

  app "Lantern.app"

  uninstall quit:      "com.getlantern.lantern",
            launchctl: "org.getlantern"

  zap trash: [
    "~LibraryApplication SupportLantern",
    "~LibraryLogsLantern",
  ]
end