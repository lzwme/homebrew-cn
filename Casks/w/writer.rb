cask "writer" do
  version "2.1.1"
  sha256 "ca71fad8d767f510ad3be08bacc4a128782fb93f8cf09b797f2b5d531750cbe1"

  url "https://ghfast.top/https://github.com/HendrikNoeller/Writer/releases/download/#{version}/Writer.app.zip"
  name "Writer"
  desc "Screenwriting app based on the fountain language"
  homepage "https://github.com/HendrikNoeller/Writer"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-09-06", because: :unmaintained

  app "Writer.app"

  zap trash: [
    "~/Library/Application Support/Writer",
    "~/Library/Preferences/de.HendrikNoeller.Writer.plist",
  ]

  caveats do
    requires_rosetta
  end
end