cask "forkgram-telegram" do
  arch arm: "arm64", intel: "x86"

  version "5.9.2"
  sha256 arm:   "ee4dba087e48b10d7d3a394534e41b5514dcb6ff76ccb591b8e24f1b2b9ed8a2",
         intel: "d8a962a500be044479c25a091f44d971135bf729eda79a85e685df0fdd094138"

  url "https:github.comForkgramtdesktopreleasesdownloadv#{version}Forkgram.macOS.no.auto-update_#{arch}.zip"
  name "Forkgram"
  desc "Fork of Telegram Desktop"
  homepage "https:github.comForkgram"

  # Not every GitHub release provides a file for macOS, so we check multiple
  # recent releases instead of only the "latest" release.
  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)$i)
    strategy :github_releases do |json, regex|
      file_regex = ^Forkgram[._-]macOS[._-].*?#{arch}\.zip$i

      json.map do |release|
        next if release["draft"] || release["prerelease"]
        next unless release["assets"]&.any? { |asset| asset["name"]&.match?(file_regex) }

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  # Renamed to avoid conflict with telegram
  app "Telegram.app", target: "Forkgram.app"

  zap trash: "~LibraryApplication SupportForkgram Desktop"
end