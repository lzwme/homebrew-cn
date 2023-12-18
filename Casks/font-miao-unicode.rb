cask "font-miao-unicode" do
  version :latest
  sha256 :no_check

  url "https:github.comphjamrMiaoUnicodeblobmasterMiaoUnicode-Regular.ttf?raw=true",
      verified: "github.comphjamrMiaoUnicode"
  name "MiaoUnicode"
  homepage "https:phjamr.github.iomiao.html"

  font "MiaoUnicode-Regular.ttf"

  # No zap stanza required
end