cask "font-lxgw-wenkai-lite" do
  version "1.330"
  sha256 "10beb11701118e6f1b301cdc2b2a2e6177e0fe53671c5f802603a9e9bd9c168d"

  url "https:github.comlxgwLxgwWenKai-Litereleasesdownloadv#{version}lxgw-wenkai-lite-v#{version}.zip"
  name "LXGW WenKai Lite"
  name "霞鹜文楷 轻便版"
  desc "Open-source Chinese font derived from Fontworks' Klee One"
  homepage "https:github.comlxgwLxgwWenKai-Lite"

  font "lxgw-wenkai-lite-v#{version}LXGWWenKaiLite-Bold.ttf"
  font "lxgw-wenkai-lite-v#{version}LXGWWenKaiLite-Light.ttf"
  font "lxgw-wenkai-lite-v#{version}LXGWWenKaiLite-Regular.ttf"
  font "lxgw-wenkai-lite-v#{version}LXGWWenKaiMonoLite-Bold.ttf"
  font "lxgw-wenkai-lite-v#{version}LXGWWenKaiMonoLite-Light.ttf"
  font "lxgw-wenkai-lite-v#{version}LXGWWenKaiMonoLite-Regular.ttf"

  # No zap stanza required
end