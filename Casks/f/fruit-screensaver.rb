cask "fruit-screensaver" do
  version "1.3.1"
  sha256 "65283975194efd3780f05457a8231e5c7514ab6d4640def5070a2a92854ad375"

  url "https://ghfast.top/https://github.com/Corkscrews/fruit/releases/download/#{version}/Fruit.saver.tar.gz"
  name "Fruit Screensaver"
  desc "Screensaver of the vintage Apple logo"
  homepage "https://github.com/Corkscrews/fruit"

  no_autobump! because: :requires_manual_review

  screen_saver "Fruit.saver"

  # No zap stanza required
end