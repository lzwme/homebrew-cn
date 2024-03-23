cask "virtualbuddy" do
  version "1.4,109"
  sha256 "2a2bf0117a3d6ac92da525d6b778f83325b2df0065ec3d9e2d9b02ab29c3031b"

  url "https:github.cominsideguiVirtualBuddyreleasesdownload#{version.csv.first}VirtualBuddy_v#{version.csv.first}-#{version.csv.second}.dmg"
  name "VirtualBuddy"
  desc "Virtualization tool"
  homepage "https:github.cominsideguiVirtualBuddy"

  livecheck do
    url :url
    regex(^VirtualBuddy[._-]v?(\d+(?:[.-]\d+)+)\.dmg$i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        match[1].tr("-", ",")
      end
    end
  end

  conflicts_with cask: "homebrewcask-versionsvirtualbuddy-beta"
  depends_on arch: :arm64
  depends_on macos: ">= :monterey"

  app "VirtualBuddy.app"

  zap trash: [
    "~LibraryApplication SupportVirtualBuddy",
    "~LibraryCachescodes.rambo.VirtualBuddy",
    "~LibraryHTTPStoragescodes.rambo.VirtualBuddy",
    "~LibraryPreferencescodes.rambo.VirtualBuddy.plist",
  ]
end