cask "headlamp" do
  arch arm: "arm64", intel: "x64"

  version "0.29.0"
  sha256 arm:   "e8b82d3d0d002239b9ef76b75101ceba5d54dfd618ad082f95c9fb65830af7e7",
         intel: "a3f226f2acc714e670b52925f9af1fb3de222027366d683a28932d7293b3d778"

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