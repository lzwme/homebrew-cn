cask "gog-galaxy" do
  version "2.0.84.122"
  sha256 "fd8f57a08862a711aab3b152e5c8e783e2d6de6c75207a8494680bd68276e2b3"

  url "https://gog-cdn-fastly.gog.com/open/galaxy/client/galaxy_client_#{version}.pkg"
  name "GOG Galaxy"
  desc "Game client"
  homepage "https://www.gog.com/galaxy"

  livecheck do
    url :homepage
    regex(/href=.*?galaxy[._-]client[._-]v?(\d+(?:\.\d+)+)\.pkg/i)
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  pkg "galaxy_client_#{version}.pkg"

  uninstall launchctl: [
              "com.gog.galaxy.autoLauncher",
              "com.gog.galaxy.ClientService",
              "com.gog.galaxy.commservice",
            ],
            delete:    "/Applications/GOG Galaxy.app"

  zap trash: [
    "/Library/LaunchDaemons/com.gog.galaxy.ClientService.plist",
    "/Library/PrivilegedHelperTools/com.gog.galaxy.ClientService",
    "/Users/Shared/GOG.com",
    "~/Library/Application Support/GOG.com",
    "~/Library/Preferences/com.gog.galaxy.cef.renderer.plist",
    "~/Library/Preferences/com.gog.galaxy.plist",
    "~/Library/Saved Application State/com.gog.galaxy.savedState",
  ]

  caveats do
    requires_rosetta
  end
end