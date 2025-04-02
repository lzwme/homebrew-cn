cask "virtualbuddy" do
  version "1.7.1,133"
  sha256 "93ebf4841ecf238b5efc8cc62fbee775841fa4f1d620e2375ae538dca65c4d77"

  url "https:su.virtualbuddy.appVirtualBuddy_v#{version.csv.first}-#{version.csv.second}.dmg",
      verified: "su.virtualbuddy.app"
  name "VirtualBuddy"
  desc "Virtualization tool"
  homepage "https:github.cominsideguiVirtualBuddy"

  livecheck do
    url "https:su.virtualbuddy.appappcast.xml?channel=release"
    strategy :sparkle
  end

  auto_updates true
  conflicts_with cask: "virtualbuddy@beta"
  depends_on arch: :arm64
  depends_on macos: ">= :ventura"

  app "VirtualBuddy.app"

  zap trash: [
    "~LibraryApplication SupportVirtualBuddy",
    "~LibraryCachescodes.rambo.VirtualBuddy",
    "~LibraryHTTPStoragescodes.rambo.VirtualBuddy",
    "~LibraryPreferencescodes.rambo.VirtualBuddy.plist",
  ]
end