cask "lobehub" do
  arch arm: "-arm64"

  version "1.94.7"
  sha256 arm:   "22acac496e66d2f4db71abb70746e2049d9e3a6cb9cacd43512589d6a61d0ce9",
         intel: "085f94d7e97104dbbbc9d75cb9c6d92ecafa20bbfdf225fbb52ccab4cd5aa42f"

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