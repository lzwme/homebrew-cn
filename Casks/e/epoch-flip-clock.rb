cask "epoch-flip-clock" do
  version "0.0.5"
  sha256 "90fa0ace6b13b47a12dc89a56c33d9add1140fecbd6bdd0c905d396fa093b02d"

  url "https://ghfast.top/https://github.com/chrstphrknwtn/epoch-flip-clock-screensaver/releases/download/#{version}/Epoch.Flip.Clock.#{version}.saver.zip"
  name "Epoch Flip Clock Screensaver"
  desc "Flip clock screensaver"
  homepage "https://github.com/chrstphrknwtn/epoch-flip-clock-screensaver/"

  no_autobump! because: :requires_manual_review

  screen_saver "Epoch Flip Clock.saver"

  # No zap stanza required
end