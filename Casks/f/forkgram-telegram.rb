cask "forkgram-telegram" do
  arch arm: "arm64", intel: "x86"

  version "5.0.0"
  sha256 arm:   "db3c036cf28b601465c69770c19dc0d8f4e8549a251afa6d19a1ecd7544df888",
         intel: "3500afbb6b7900829bac2eb036972ae6a0e706e5ed38195ecf7f0d701d8f85bd"

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

        match = release["tag_name"].match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  # Renamed to avoid conflict with telegram
  app "Telegram.app", target: "Forkgram.app"

  zap trash: "~LibraryApplication SupportForkgram Desktop"
end