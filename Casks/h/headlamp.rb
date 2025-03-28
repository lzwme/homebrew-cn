cask "headlamp" do
  arch arm: "arm64", intel: "x64"

  version "0.30.0"
  sha256 arm:   "28e75c8525c17c7c901d0682f857a1a68277c11f4f848e0483d511a67357ade7",
         intel: "8011524f7a6d73bcf19239cf7c3e2c53cf184a00bf64072f774d937817bc6568"

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