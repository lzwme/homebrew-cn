cask "pivy" do
  version "0.11.2"
  sha256 "a8249869cc6a922eabe80ac64e5895b503a4f2d23007b21497aa0aca11e2b20c"

  url "https:github.comjoyentpivyreleasesdownloadv#{version}pivy-#{version}-macos12.pkg"
  name "pivy"
  desc "Client for PIV cards"
  homepage "https:github.comjoyentpivy"

  pkg "pivy-#{version}-macos12.pkg"

  uninstall pkgutil:   "net.cooperi.pivy",
            launchctl: "net.cooperi.pivy-agent",
            quit:      "net.cooperi.pivy-agent"

  # No zap stanza required

  caveats "The installer will prompt you to insert a YubiKey or other PIV token via a dialog box."
end