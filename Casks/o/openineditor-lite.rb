cask "openineditor-lite" do
  version "1.2.7"
  sha256 "c079751dc86ac4a683840e62b05872acc4dfbb08d2c7019bb3c6b9d88a0c8017"

  url "https:github.comJi4n1ngOpenInTerminalreleasesdownloadv#{version}OpenInEditor-Lite.zip"
  name "OpenInEditor-Lite"
  desc "Finder Toolbar app to open the current directory in Editor"
  homepage "https:github.comJi4n1ngOpenInTerminal"

  # Not every GitHub release provides a `openineditor-lite` file, so we check multiple
  # recent releases instead of only the "latest" release.
  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)$i)
    strategy :github_releases do |json, regex|
      file_regex = ^OpenInEditor[._-]Lite\.zip$i

      json.map do |release|
        next if release["draft"] || release["prerelease"]
        next unless release["assets"]&.any? { |asset| asset["name"]&.match?(file_regex) }

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :sierra"

  app "OpenInEditor-Lite.app"

  zap trash: "~LibraryPreferenceswang.jianing.app.OpenInEditor-Lite.plist"
end