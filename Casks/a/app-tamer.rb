cask "app-tamer" do
  version "2.8"
  sha256 "a7c3c364abf1c9c7952a88cd559061ca3109c6371c57f7ec3d9835961f0ddff4"

  url "https://www.stclairsoft.com/download/AppTamer-#{version}.dmg"
  name "AppTamer"
  desc "CPU management application"
  homepage "https://www.stclairsoft.com/AppTamer/"

  livecheck do
    url "https://www.stclairsoft.com/cgi-bin/sparkle.cgi?AT"
    strategy :sparkle, &:short_version
  end

  depends_on macos: ">= :high_sierra"

  app "App Tamer.app"

  uninstall delete: [
    "/Library/LaunchDaemons/com.stclairsoft.AppTamerAgent.plist",
    "/Library/PrivilegedHelperTools/com.stclairsoft.AppTamerAgent",
  ]

  zap trash: [
    "~/Library/Caches/com.stclairsoft.AppTamer",
    "~/Library/Preferences/com.stclairsoft.AppTamer.plist",
  ]
end