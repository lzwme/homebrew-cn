cask "virtualbuddy@beta" do
  version "2.1,323"
  sha256 "422b3b59546496a1d74ce3442f8cd028070642bd6a97e787bb7606b408b14199"

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