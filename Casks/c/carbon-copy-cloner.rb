cask "carbon-copy-cloner" do
  version "6.1.7.7589"
  sha256 "73bf59d1e7a309016c5a29b142bf271c6ecd4b25e514cd7d430f2a4ac5ea67c6"

  url "https://bombich.scdn1.secure.raxcdn.com/software/files/ccc-#{version}.zip",
      verified: "bombich.scdn1.secure.raxcdn.com/software/files/"
  name "Carbon Copy Cloner"
  desc "Hard disk backup and cloning utility"
  homepage "https://bombich.com/"

  livecheck do
    url "https://bombich.com/software/download_ccc.php?v=latest"
    strategy :header_match
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Carbon Copy Cloner.app"

  uninstall login_item: "CCC User Agent",
            quit:       [
              "com.bombich.ccc",
              "com.bombich.cccuseragent",
            ]

  zap trash: [
    "~/Library/Application Support/com.bombich.ccc",
    "~/Library/Caches/com.bombich.ccc",
    "~/Library/Preferences/com.bombich.ccc.plist",
    "~/Library/Preferences/com.bombich.cccuseragent.plist",
    "~/Library/Saved Application State/com.bombich.ccc.savedState",
    "/Library/LaunchDaemons/com.bombich.ccchelper.plist",
  ]
end