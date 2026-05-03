cask "motionik" do
  arch arm: "arm64", intel: "x64"

  version "2.1.3"
  sha256 arm:   "3dde7519086d42dce784c97bdba09b83fc2ff81860e6cd888e15301f59f06e79",
         intel: "0a691e5d4cf568bab72d86a6334f35ebcb0d8c1ce85e59028d8a6398056c97ed"

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