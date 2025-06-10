cask "virtualbuddy@beta" do
  version "2.0,275"
  sha256 "cafb59bb9195613d2fcac58ed225c1e63bd2047526e4ab4f15120d2152773cc5"

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