cask "virtualbuddy@beta" do
  version "2.0.1,278"
  sha256 "5dffea4a73e4e5a8f51c1b66d6edee78fc96c579c9f0dd827310747701227a43"

  url "https:su.virtualbuddy.appbetaVirtualBuddy_v#{version.csv.first}-#{version.csv.second}.dmg",
      verified: "su.virtualbuddy.app"
  name "VirtualBuddy"
  desc "Virtualization tool"
  homepage "https:github.cominsideguiVirtualBuddy"

  livecheck do
    url "https:su.virtualbuddy.appappcast.xml?channel=beta"
    strategy :sparkle
  end

  conflicts_with cask: "virtualbuddy"
  depends_on arch: :arm64
  depends_on macos: ">= :ventura"

  app "VirtualBuddy.app"
  binary "#{appdir}VirtualBuddy.appContentsMacOSvctool", target: "vctool"

  zap trash: [
    "~LibraryApplication SupportVirtualBuddy",
    "~LibraryHTTPStoragescodes.rambo.VirtualBuddy",
    "~LibraryPreferencescodes.rambo.VirtualBuddy.plist",
  ]
end