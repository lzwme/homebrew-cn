cask "motionik" do
  arch arm: "arm64", intel: "x64"

  version "2.1.0"
  sha256 arm:   "3610094ee719e248b9ecd06d58f982eb23e4ab0c9fe88c0be931645e6d95f569",
         intel: "73969a8feda95a2f61d8e7a38f481a82de296a8b102d0bc18370ccbc64337726"

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