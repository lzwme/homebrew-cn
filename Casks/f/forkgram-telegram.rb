cask "forkgram-telegram" do
  arch arm: "arm64", intel: "x86"

  version "5.15.3"
  sha256 arm:   "bc4b6a782b121c11f982f1c2e59f0166990a456a92c868fc953923eec2586fee",
         intel: "f2b7ac74d67d102488e3717f8ce495823a92dda18545589cb8d39dfc6747935b"

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

  depends_on macos: ">= :high_sierra"

  # Renamed to avoid conflict with telegram
  app "Telegram.app", target: "Forkgram.app"

  zap trash: "~LibraryApplication SupportForkgram Desktop"
end