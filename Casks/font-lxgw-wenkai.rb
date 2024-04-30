cask "font-lxgw-wenkai" do
  version "1.330"
  sha256 "2f317e15480608cabf471cbabdbc5f524066d0bbb177a3f439c7b5ee7b61780c"

  url "https:github.comlxgwLxgwWenKaireleasesdownloadv#{version}lxgw-wenkai-v#{version}.zip"
  name "LXGW WenKai"
  name "霞鹜文楷"
  desc "Open-source Chinese font derived from Fontworks' Klee One"
  homepage "https:github.comlxgwLxgwWenKai"

  font "lxgw-wenkai-v#{version}LXGWWenKai-Bold.ttf"
  font "lxgw-wenkai-v#{version}LXGWWenKai-Light.ttf"
  font "lxgw-wenkai-v#{version}LXGWWenKai-Regular.ttf"
  font "lxgw-wenkai-v#{version}LXGWWenKaiMono-Bold.ttf"
  font "lxgw-wenkai-v#{version}LXGWWenKaiMono-Light.ttf"
  font "lxgw-wenkai-v#{version}LXGWWenKaiMono-Regular.ttf"

  # No zap stanza required
end