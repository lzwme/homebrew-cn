cask "virtualbuddy@beta" do
  version "2.0,203,b2"
  sha256 "1cbac59a0578e4a0914fa7a2b423bfaa6f567a61a4d9bbd18e213f4f5635bb41"

  url "https:github.cominsideguiVirtualBuddyreleasesdownload#{version.csv.first}#{"-#{version.csv.third}" if version.csv.third}VirtualBuddy_v#{version.csv.first}-#{version.csv.second}.dmg"
  name "VirtualBuddy"
  desc "Virtualization tool"
  homepage "https:github.cominsideguiVirtualBuddy"

  livecheck do
    url :url
    regex(^VirtualBuddy[._-]v?(\d+(?:[.-]\d+)+)\.dmg$i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"]

        tag_suffix = release["tag_name"]&.[](-(.+)$i, 1)

        release["assets"]&.map do |asset|
          match = asset["name"]&.match(regex)
          next if match.blank?

          tag_suffix ? "#{match[1].tr("-", ",")},#{tag_suffix}" : match[1].tr("-", ",")
        end
      end.flatten
    end
  end

  conflicts_with cask: "virtualbuddy"
  depends_on arch: :arm64
  depends_on macos: ">= :ventura"

  app "VirtualBuddy.app"

  zap trash: [
    "~LibraryApplication SupportVirtualBuddy",
    "~LibraryHTTPStoragescodes.rambo.VirtualBuddy",
    "~LibraryPreferencescodes.rambo.VirtualBuddy.plist",
  ]
end