cask "font-zhuque-fangsong" do
  version "0.211"
  sha256 "4141782e9f36bc669d042422505f5c506df47930ee7bfa82342d8cec631f8f10"

  url "https://ghfast.top/https://github.com/TrionesType/zhuque/releases/download/v#{version}/ZhuqueFangsong-v#{version}.zip"
  name "Zhuque Fangsong"
  name "朱雀仿宋"
  homepage "https://github.com/TrionesType/zhuque"

  no_autobump! because: :requires_manual_review

  font "ZhuqueFangsong-Regular.ttf"

  # No zap stanza required
end