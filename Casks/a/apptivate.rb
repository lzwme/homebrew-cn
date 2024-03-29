cask "apptivate" do
  version "2.2.1,15"
  sha256 :no_check

  url "http://www.apptivateapp.com/resources/Apptivate.app.zip"
  name "Apptivate"
  desc "Create global hotkeys for your files and applications"
  homepage "http://www.apptivateapp.com/"

  livecheck do
    url :url
    strategy :extract_plist
  end

  app "Apptivate.app"

  zap trash: [
    "~/Library/Application Support/Apptivate",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/se.cocoabeans.apptivate.sfl*",
    "~/Library/Preferences/se.cocoabeans.apptivate.plist",
  ]
end