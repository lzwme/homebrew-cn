cask "lobehub" do
  arch arm: "-arm64"

  version "1.91.0"
  sha256 arm:   "4141335495c179547361a9d7c645252836e738f30e258358991ebec8bb43b354",
         intel: "3b0dc0b46c4f50a6800984ee5e05fbdb88d2da32fbdf78265e49ee8adde1e7a1"

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