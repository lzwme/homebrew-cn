cask "font-lxgw-wenkai-mono-tc" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofllxgwwenkaimonotc"
  name "LXGW WenKai Mono TC"
  homepage "https:fonts.google.comspecimenLXGW+WenKai+Mono+TC"

  font "LXGWWenKaiMonoTC-Bold.ttf"
  font "LXGWWenKaiMonoTC-Light.ttf"
  font "LXGWWenKaiMonoTC-Regular.ttf"

  # No zap stanza required
end