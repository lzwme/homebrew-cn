cask "font-last-resort" do
  version "16.000"
  sha256 "f7b2a5ddecf37e3c9d5a4388eb291430f3382b304470b48677f3d40f93d29166"

  url "https:github.comunicode-orglast-resort-fontreleasesdownload#{version}LastResort-Regular.ttf"
  name "Last Resort"
  homepage "https:github.comunicode-orglast-resort-font"

  no_autobump! because: :requires_manual_review

  font "LastResort-Regular.ttf"

  # No zap stanza required
end