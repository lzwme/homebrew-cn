cask "gitahead" do
  version "2.7.0"
  sha256 "53bfa4c78b01f2a0843468ac9791f50c60833126d828993245ccae9ff00ef8f6"

  url "https:github.comgitaheadgitaheadreleasesdownloadv#{version}GitAhead-#{version}.dmg"
  name "GitAhead"
  homepage "https:github.comgitaheadgitahead"

  depends_on macos: ">= :sierra"

  app "GitAhead.app"
end