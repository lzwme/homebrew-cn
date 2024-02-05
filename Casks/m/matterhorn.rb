cask "matterhorn" do
  version "90000.0.0"
  sha256 "c49f9ad49ca745f629c1251eb4a75d6e8ff7c678aefa93939977bde1fb4223ff"

  url "https:github.commatterhorn-chatmatterhornreleasesdownload#{version}matterhorn-#{version}-Darwin-x86_64.tar.bz2"
  name "Matterhorn"
  desc "Unix terminal client for Mattermost"
  homepage "https:github.commatterhorn-chatmatterhorn"

  binary "matterhorn-#{version}-Darwin-x86_64matterhorn"

  # No zap stanza required
end