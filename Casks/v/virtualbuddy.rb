cask "virtualbuddy" do
  version "1.6,129"
  sha256 "e61487ddeb6228f174d173a27dccddc57d57e72c8683da94a5afdeac3731ea29"

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

  auto_updates true
  conflicts_with cask: "virtualbuddy@beta"
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