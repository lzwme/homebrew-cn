cask "apple-events" do
  version "1.6"
  sha256 "00dee705888f2e7f8f036afe06bafb7d70042bd1eaa1bdf93146fddb63bc8e76"

  url "https:github.cominsideguiAppleEventsreleasesdownload#{version}AppleEvents_v#{version}.zip"
  name "Apple Events"
  desc "Unofficial Apple Events app"
  homepage "https:github.cominsideguiAppleEvents"

  disable! date: "2024-12-16", because: :discontinued

  auto_updates true

  app "Apple Events.app"

  zap trash: [
    "~LibraryApplication Supportbr.com.guilhermerambo.Apple-Events",
    "~LibraryCachesbr.com.guilhermerambo.Apple-Events",
    "~LibraryPreferencesbr.com.guilhermerambo.Apple-Events.plist",
  ]
end