cask "tomatobar" do
  version "3.5.0"
  sha256 "f5b29a3761d60a952697fa9f8f9e1c86350ee6f18d4e94eb2e9093ab7cb61e72"

  url "https://ghfast.top/https://github.com/ivoronin/TomatoBar/releases/download/v#{version}/TomatoBar-v#{version}.zip"
  name "TomatoBar"
  desc "Menu bar pomodoro timer"
  homepage "https://github.com/ivoronin/TomatoBar"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :big_sur"

  app "TomatoBar.app"

  zap trash: [
    "~/Library/Application Scripts/com.github.ivoronin.TomatoBar",
    "~/Library/Containers/com.github.ivoronin.TomatoBar",
  ]
end