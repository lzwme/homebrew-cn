cask "headlamp" do
  arch arm: "arm64", intel: "x64"

  version "0.27.0"
  sha256 arm:   "d4ed9d1fe4313053ac5be577e12fdddbdc8495bef415147b518e81cdd3644249",
         intel: "a5e8b2821890012e2c5ef0695863a5d83bbbc66d64bc6a057a036fac6f2ad9c0"

  url "https:github.comheadlamp-k8sheadlampreleasesdownloadv#{version.sub(-\d+, "")}Headlamp-#{version}-mac-#{arch}.dmg",
      verified: "github.comheadlamp-k8sheadlamp"
  name "Headlamp"
  desc "UI for Kubernetes"
  homepage "https:headlamp.dev"

  livecheck do
    url :url
    regex(Headlamp[._-]v?(\d+(?:[.-]\d+)+)-mac-#{arch}i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  depends_on macos: ">= :catalina"

  app "Headlamp.app"

  uninstall quit: "com.kinvolk.headlamp"

  zap trash: [
    "~LibraryApplication SupportHeadlamp",
    "~LibraryLogsHeadlamp",
    "~LibraryPreferencescom.kinvolk.headlamp.plist",
  ]
end