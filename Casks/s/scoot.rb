cask "scoot" do
  version "1.2"
  sha256 "99fb59e9f4e94b9094c4d219c6f376b36a5cb29057b032adc354eda6582c2883"

  url "https://ghfast.top/https://github.com/mjrusso/scoot/releases/download/v#{version}/Scoot.app.zip"
  name "Scoot"
  desc "Keyboard-driven cursor actuator"
  homepage "https://github.com/mjrusso/scoot"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :big_sur"

  app "Scoot.app"

  zap trash: [
    "~/Library/Application Scripts/com.mjrusso.Scoot",
    "~/Library/Containers/com.mjrusso.Scoot",
    "~/Library/Preferences/com.mjrusso.Scoot.plist",
  ]
end