cask "firezone" do
  version "1.5.3"
  sha256 "9bce554626d590841d8dd8157e40f45e1544d06b84e6302c5455fd12270859e4"

  url "https:github.comfirezonefirezonereleasesdownloadmacos-client-#{version}firezone-macos-client-#{version}.dmg",
      verified: "github.comfirezonefirezone"
  name "Firezone"
  desc "Zero-trust access platform built on WireGuard"
  homepage "https:www.firezone.dev"

  livecheck do
    url "https:www.firezone.devdlfirezone-client-macoslatest"
    strategy :header_match
  end

  depends_on macos: ">= :monterey"

  app "Firezone.app"

  # The app installs a system extension that cannot be removed systematically at this time.
  # After the limitation is removed, `systemextensionsctl uninstall "dev.firezone.firezone.network-extension"`
  # could be used to uninstall the extension.
  zap trash: [
    "~LibraryApplication Scripts*.dev.firezone.firezone",
    "~LibraryContainersdev.firezone.firezone,",
    "~LibraryGroup Containers*.dev.firezone.firezone",
  ]
end