cask "matterhorn" do
  version "50200.19.0"
  sha256 "2f674a1a9deefc54cd4522aaba6e808b0f9321432238c9c1feccebe0d474ffd7"

  url "https:github.commatterhorn-chatmatterhornreleasesdownload#{version}matterhorn-#{version}-Darwin-x86_64.tar.bz2"
  name "Matterhorn"
  desc "Unix terminal client for Mattermost"
  homepage "https:github.commatterhorn-chatmatterhorn"

  binary "matterhorn-#{version}-Darwin-x86_64matterhorn"

  # No zap stanza required
end