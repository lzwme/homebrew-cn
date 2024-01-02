cask "qnapi" do
  version "0.2.3"
  sha256 "9bb7f9ba42f6795c7e094ba6555e14955e02b5e2f5277454dc4a96b1569871d1"

  url "https:github.comQNapiqnapireleasesdownload#{version}QNapi-#{version}.dmg",
      verified: "github.comQNapiqnapi"
  name "QNapi"
  homepage "https:qnapi.github.io"

  # it has been almost seven years since the last release,
  # and users have reported it stopped working in 2020
  # https:github.comQNapiqnapiissues173
  disable! date: "2024-01-01", because: :unmaintained

  app "QNapi.app"
end