cask "motionik" do
  arch arm: "arm64", intel: "x64"

  version "2.0.3"
  sha256 arm:   "ceb60c552ccba989e4b3f5d908b310cb8cd1845bc0f2fc7acb3dfa2d1801a9e3",
         intel: "185dbbe51ed32ae343ca6f6013610bcfdca75abfdec050ce96a3d33d5ce5cc3c"

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