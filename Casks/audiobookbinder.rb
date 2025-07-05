cask "audiobookbinder" do
  version "2.4"
  sha256 "9d87547fa3355444acd134f7a964f817b6f6bad5d2a8528e6a6ba8f592c2b7b0"

  # homepage "http://bluezbox.com/audiobookbinder.html"
  # homepage "https://web.archive.org/web/20220627063508/http://bluezbox.com/audiobookbinder.html"
  # appcast "https://bluezbox.com/audiobookbinder/appcast.xml"
  # url "https://bluezbox.com/audiobookbinder/AudiobookBinder-#{version.before_comma}.dmg"

  url "https://ghfast.top/https://github.com/nicerloop/AudioBookBinder/releases/download/v#{version}/AudiobookBinder-#{version}.zip"
  name "Audiobook Binder"
  desc "Utility for converting audiobooks to m4b format"
  homepage "https://github.com/gonzoua/AudioBookBinder"

  app "AudioBookBinder.app"
end