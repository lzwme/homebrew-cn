cask "linkliar" do
  on_el_capitan :or_older do
    version "1.1.3"
    sha256 "34c9baeaf1d6732c8ce9add689b281f9b71fddadd8f56cca614cba4f8c167962"
  end
  on_sierra :or_newer do
    version "3.0.3"
    sha256 "36e62eab4ef8d2b004c6886182fc49830afdf56f4f14f9be07adfe552d7140d2"
  end

  url "https:github.comhaloLinkLiarreleasesdownload#{version}LinkLiar.app.zip"
  name "LinkLiar"
  desc "Link-Layer MAC spoofing GUI for macOS"
  homepage "https:github.comhaloLinkLiar"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "LinkLiar.app"

  uninstall launchctl: [
              "io.github.halo.linkdaemon",
              "io.github.halo.linkhelper",
            ],
            quit:      "io.github.halo.LinkLiar",
            delete:    [
              "LibraryApplication Supportio.github.halo.linkdaemon",
              "LibraryApplication SupportLinkLiar",
            ]

  # No zap stanza required
end