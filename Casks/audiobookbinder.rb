cask "audiobookbinder" do
  version "2.4"
  sha256 "9d87547fa3355444acd134f7a964f817b6f6bad5d2a8528e6a6ba8f592c2b7b0"

  # homepage "http:bluezbox.comaudiobookbinder.html"
  # homepage "https:web.archive.orgweb20220627063508http:bluezbox.comaudiobookbinder.html"
  # appcast "https:bluezbox.comaudiobookbinderappcast.xml"
  # url "https:bluezbox.comaudiobookbinderAudiobookBinder-#{version.before_comma}.dmg"

  url "https:github.comnicerloopAudioBookBinderreleasesdownloadv#{version}AudiobookBinder-#{version}.zip"
  name "Audiobook Binder"
  desc "Utility for converting audiobooks to m4b format"
  homepage "https:github.comgonzouaAudioBookBinder"

  app "AudioBookBinder.app"
end