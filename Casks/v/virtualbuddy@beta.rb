cask "virtualbuddy@beta" do
  version "2.1,309"
  sha256 "bbe1496c1bd95ab48864871f9a1c98b44384f3f98758d1357057d8c6952bec46"

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