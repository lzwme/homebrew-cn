cask "font-lxgw-wenkai-mono-tc" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      branch:    "main",
      only_path: "ofllxgwwenkaimonotc"
  name "LXGW WenKai Mono TC"
  homepage "https:github.comaaronbellLxgwWenkaiTC"

  font "LXGWWenKaiMonoTC-Bold.ttf"
  font "LXGWWenKaiMonoTC-Light.ttf"
  font "LXGWWenKaiMonoTC-Regular.ttf"

  # No zap stanza required
end