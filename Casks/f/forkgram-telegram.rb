cask "forkgram-telegram" do
  arch arm: "arm64", intel: "x86"

  version "5.7.3"
  sha256 arm:   "3930d9fce675f2508d0d5c392b1ab420ab92c1994644c392b3fb243ce76d79ee",
         intel: "c812469ebd0b8f343cd28f4d31436e85750305cadb45e37b559fa62c853295ac"

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