cask "motionik" do
  arch arm: "arm64", intel: "x64"

  version "2.0.9"
  sha256 arm:   "42e70b4b0e1ffe2e473fef34602e17be00357a3e7bafbbb8e72ee55beffe1822",
         intel: "5e2f9a9dd4fcef44352a72f090ebfcb782cdd0a2c7251324acf8d3c0cebef2d8"

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