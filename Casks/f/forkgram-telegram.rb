cask "forkgram-telegram" do
  arch arm: "arm64", intel: "x86"

  version "4.14.10"
  sha256 arm:   "90239e9c1c78dda69f3c0e5245aedf0c4f25bb93b64e68b244b458e385dc2fa9",
         intel: "501dac566129f43f265b3f1e30407ab00e8266075fead0d22dd134132bf0251d"

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