cask "headlamp" do
  arch arm: "arm64", intel: "x64"

  version "0.26.0"
  sha256 arm:   "5786bf7333c70fd27a350993bc7f0fab81d36ce6165070c38998cdbe2b192d71",
         intel: "2d88bc3693f70a09c33258f5c4c4c7558a9d6509615031394fa3a94e95e6bd0a"

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