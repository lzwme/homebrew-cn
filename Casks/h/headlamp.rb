cask "headlamp" do
  arch arm: "arm64", intel: "x64"

  version "0.31.0"
  sha256 arm:   "da2d17c3f5f1c42c01b67c53528e36c7aaa635425573180e927f5a19d54e1ae7",
         intel: "4e98bffdb74ac82de157aa2c1df79d6ed7fb705489e93b3ede711cf4392446b0"

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

  no_autobump! because: :bumped_by_upstream

  app "Headlamp.app"

  uninstall quit: "com.kinvolk.headlamp"

  zap trash: [
    "~LibraryApplication SupportHeadlamp",
    "~LibraryLogsHeadlamp",
    "~LibraryPreferencescom.kinvolk.headlamp.plist",
  ]
end