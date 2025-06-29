cask "shortcuts" do
  version "1.0.1"
  sha256 "5494da4a8fb18471dd98aa5087820087463dc20e16ca6eb7c7ccde5e910f432c"

  url "https:github.comsiong1987shortcutsreleasesdownload#{version}restart.sleep.shutdown.logout.lock.zip"
  name "RestartSleepLogoutShutdownLock Shortcuts"
  homepage "https:github.comsiong1987shortcuts"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-09-08", because: :unmaintained

  suite "system", target: "Shortcuts"

  caveats do
    requires_rosetta
  end
end