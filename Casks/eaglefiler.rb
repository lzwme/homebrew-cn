cask "eaglefiler" do
  version "1.9.10"
  sha256 "0cf75c3cd92fd5b616a5b5e10571809d6b7d9efc82467db16066201a88045a89"

  url "https://c-command.com/downloads/EagleFiler-#{version}.dmg"
  name "EagleFiler"
  desc "Organize files, archive e-mails, save Web pages and notes, search everything"
  homepage "https://c-command.com/eaglefiler/"

  livecheck do
    url :homepage
    regex(%r{href=.*?/EagleFiler[._-]v?(\d+(?:\.\d+)+)\.dmg}i)
  end

  app "EagleFiler.app"

  zap trash: [
    "~/Library/Application Scripts/com.c-command.EagleFiler.EagleFilerShare",
    "~/Library/Application Support/EagleFiler",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.c-command.eaglefiler.sfl2",
    "~/Library/Caches/com.c-command.EagleFiler",
    "~/Library/Containers/com.c-command.EagleFiler.EagleFilerShare",
    "~/Library/HTTPStorages/com.c-command.EagleFiler",
    "~/Library/Logs/EagleFiler",
    "~/Library/PDF Services/Save PDF to EagleFiler",
    "~/Library/Preferences/com.c-command.EagleFiler.plist",
    "~/Library/Saved Application State/com.c-command.EagleFiler.savedState",
  ]
end