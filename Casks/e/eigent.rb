cask "eigent" do
  arch arm: "-arm64"

  sha256 arm:   "87be87fe37a6aaf1b79b702a59bed5f4cfc796a1df97294f9f6a73403629b95f",
         intel: "97002206bd87b54756198db200c1a08a6d503bdc889d54c7f71a8dcef05b9416"

  on_arm do
    version "0.0.86"
  end
  on_intel do
    version "0.0.86"
  end

  url "https://ghfast.top/https://github.com/eigent-ai/eigent/releases/download/v#{version}/Eigent-#{version}#{arch}.dmg",
      verified: "github.com/eigent-ai/eigent/"
  name "Eigent"
  desc "Desktop AI agent"
  homepage "https://www.eigent.ai/"

  # Not every GitHub release provides a file for each architecture, so we check multiple
  # recent releases instead of only the "latest" release.
  livecheck do
    url :url
    regex(/^Eigent[._-]v?(\d+(?:\.\d+)+)#{arch}\.dmg$/i)
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

  depends_on macos: ">= :big_sur"

  app "Eigent.app"

  zap trash: [
    "~/.eigent",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.eigent.app.sfl*",
    "~/Library/Application Support/eigent",
    "~/Library/Logs/eigent",
    "~/Library/Preferences/com.eigent.app.plist",
  ]
end