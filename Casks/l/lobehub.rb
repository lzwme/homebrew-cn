cask "lobehub" do
  arch arm: "-arm64"

  version "1.94.11"
  sha256 arm:   "b9428a47ea1e88e777d85ac13afed84449d03a8af69debd80cc805633dfee2cd",
         intel: "2e489b7a738251d3cbaaf73c684a1eff7946d96fe430277b7ff751ef45b38f42"

  url "https:github.comlobehublobe-chatreleasesdownloadv#{version}LobeHub-Beta-#{version}#{arch}-mac.zip"
  name "LobeHub"
  desc "AI chat framework"
  homepage "https:github.comlobehublobe-chat"

  # Not every GitHub release provides a file for macOS, so we check multiple
  # recent releases instead of only the "latest" release.
  livecheck do
    url :url
    regex(^LobeHub(?:[._-]Beta)?[._-]v?(\d+(?:\.\d+)+)#{arch}[._-]mac\.zip$i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]

        release["assets"]&.map do |asset|
          match = asset["name"]&.match(regex)
          next if match.blank?

          match[1]
        end
      end.flatten
    end
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "LobeHub-Beta.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.lobehub.lobehub-desktop-beta.sfl*",
    "~LibraryApplication SupportLobeHub-Beta",
    "~LibraryLogsLobeHub-Beta",
    "~LibraryPreferencescom.lobehub.lobehub-desktop-beta.plist",
  ]
end