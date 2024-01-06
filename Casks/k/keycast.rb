cask "keycast" do
  version "1.1"
  sha256 "61c382ee6aafa393470b86a833a93ecbe1ce91a5665f273109631733facdb727"

  url "https:github.comcho45KeyCastreleasesdownloadv#{version}KeyCast.dmg"
  name "KeyCast"
  desc "Record keystroke for screencast"
  homepage "https:github.comcho45KeyCast"

  deprecate! date: "2024-01-05", because: :discontinued

  app "KeyCast.app"
end