cask "motionik" do
  arch arm: "arm64", intel: "x64"

  version "2.1.4"
  sha256 arm:   "4c3b7b74289fc585af57fd281403a7faa40dca391844cbecccd0551ac2acc0f5",
         intel: "dfd242b561c2654a05e41c6f2e33e33a061063cd10cbe94f42955c1c2d50a198"

  url "https://assets.motionik.com/releases/Motionik-#{version}-#{arch}.dmg"
  name "Motionik"
  desc "Screen recording software"
  homepage "https://motionik.com/"

  livecheck do
    url "https://assets.motionik.com/releases/latest-mac.yml"
    strategy :electron_builder
  end

  depends_on macos: ">= :ventura"

  app "Motionik.app"

  zap trash: [
        "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.motionik.screenrecorder.sfl*",
        "~/Library/Application Support/motionik",
        "~/Library/Logs/motionik",
        "~/Library/Preferences/com.motionik.screenrecorder.plist",
      ],
      rmdir: "~/Motionik-Recordings"
end