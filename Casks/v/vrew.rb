cask "vrew" do
  version "2.12.6"
  sha256 "b2f849e6464bf095e1f50b969afc0c497a019368b50f13840ab9afdfb5495e1d"

  url "https://vrew-files.voyagerx.com/Vrew-#{version}.dmg"
  name "Vrew"
  desc "Video editor"
  homepage "https://vrew.voyagerx.com/"

  livecheck do
    url "https://s3-ap-northeast-2.amazonaws.com/vrew-files.voyagerx.com/latest-mac.yml"
    strategy :electron_builder
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Vrew.app"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.voyagerx.vrew.sfl*",
    "~/Library/Application Support/vrew",
    "~/Library/Preferences/com.voyagerx.vrew.plist",
    "~/Library/Saved Application State/com.voyagerx.vrew.savedState",
  ]
end