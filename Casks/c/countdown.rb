cask "countdown" do
  version "0.1.0"
  sha256 "3616d9c01d79e14f8db01d492c882700bfcca6c4bf886f1a73e36ad04893213c"

  url "https:github.comsoffesCountdownreleasesdownloadv#{version}Countdown.saver-#{version}.zip"
  name "Countdown Screensaver"
  homepage "https:github.comsoffesCountdown"

  # no releases in the past 8 years, and no commits in the past 6 years
  # users have reported that it stopped working
  # https:github.comsoffesCountdownissues8
  # https:github.comsoffesCountdownissues11
  disable! date: "2024-01-01", because: :unmaintained

  screen_saver "Countdown.saver"
end