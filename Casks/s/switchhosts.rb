cask "switchhosts" do
  arch arm: "arm64", intel: "x64"

  version "4.2.0.6119"
  sha256 arm:   "28491e01af40f1f9e4b7032177cdb39b6af1cc92813958c6820c1a1758fda611",
         intel: "71e1ac2fd425a80fc6ad290b2849c3f1bda8fe385d4f3f9cd205ddf0be7ddc32"

  url "https:github.comoldjSwitchHostsreleasesdownloadv#{version.major_minor_patch}SwitchHosts_mac_#{arch}_#{version}.dmg",
      verified: "github.comoldjSwitchHosts"
  name "SwitchHosts"
  desc "App to switch hosts"
  homepage "https:switchhosts.vercel.app"

  livecheck do
    url :url
    regex(^SwitchHosts_mac_#{arch}[._-]v?(\d+(?:\.\d+)+)\.dmg$i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  depends_on macos: ">= :catalina"

  app "SwitchHosts.app"

  zap trash: [
    "~.SwitchHosts",
    "~LibraryApplication SupportSwitchHosts",
    "~LibraryPreferencesSwitchHosts.plist",
    "~LibrarySaved Application StateSwitchHosts.savedState",
  ]
end