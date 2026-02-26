cask "onlyoffice" do
  arch arm: "arm", intel: "x86_64"

  version "9.3.0"
  sha256 arm:   "3e76b1b36ed4c96d37e6927af299f21ce47b9dff398aabecfa22b2193dcd47b5",
         intel: "3ec763309c8621f3e05798c07e3af92f9856c70fe7ff6f8ffbd05101aead8502"

  url "https://download.onlyoffice.com/install/desktop/editors/mac/#{arch}/updates/ONLYOFFICE-#{arch}-#{version}.zip"
  name "ONLYOFFICE"
  desc "Document editor"
  homepage "https://www.onlyoffice.com/"

  # Older items in the Sparkle feed may have a newer pubDate, so it's necessary
  # to work with all of the items in the feed (not just the newest one).
  livecheck do
    url "https://download.onlyoffice.com/install/desktop/editors/mac/#{arch}/onlyoffice.xml"
    strategy :sparkle do |items|
      items.map(&:short_version)
    end
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "ONLYOFFICE.app"

  zap trash: [
    "~/Library/Application Support/asc.onlyoffice.ONLYOFFICE",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/asc.onlyoffice.onlyoffice.sfl*",
    "~/Library/HTTPStorages/asc.onlyoffice.ONLYOFFICE",
    "~/Library/Preferences/asc.onlyoffice.editors-helper-renderer.plist",
    "~/Library/Preferences/asc.onlyoffice.ONLYOFFICE.plist",
  ]
end