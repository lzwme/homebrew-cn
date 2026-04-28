cask "motionik" do
  arch arm: "arm64", intel: "x64"

  version "2.0.6"
  sha256 arm:   "057ec096e961f6b800cb64a2232eb02200bcc770fa72bddbde05d7ca0864a9e9",
         intel: "7b7a1bc24e88d4abe67f87fdcd45ad9eb6584c431bbb2888ec7a85766d9fab60"

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