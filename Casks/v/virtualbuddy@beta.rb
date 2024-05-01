cask "virtualbuddy@beta" do
  version "1.3,100"
  sha256 "599b848a8d2dd13e1bde0785f2fd68e60ab795d98e5f1fa3d8ea70f28b3a42d9"

  url "https:github.cominsideguiVirtualBuddyreleasesdownload#{version.csv.first}-betaVirtualBuddy_v#{version.csv.first}-#{version.csv.second}.dmg"
  name "VirtualBuddy"
  desc "Virtualization tool"
  homepage "https:github.cominsideguiVirtualBuddy"

  livecheck do
    skip "No reliable way to get version info"
  end

  conflicts_with cask: "virtualbuddy"
  depends_on arch: :arm64
  depends_on macos: ">= :monterey"

  app "VirtualBuddy.app"

  zap trash: [
    "~LibraryApplication SupportVirtualBuddy",
    "~LibraryHTTPStoragescodes.rambo.VirtualBuddy",
    "~LibraryPreferencescodes.rambo.VirtualBuddy.plist",
  ]
end