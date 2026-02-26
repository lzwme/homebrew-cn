cask "butterkit" do
  version "1.7.20"
  sha256 "a4b16fe4b4746ae8f63cb9f101d0e025428dbe2f1dcf0fd8546abc996abf5d03"

  url "https://butterkit.app/updates/ButterKit-Direct-#{version}-macOS.zip"
  name "ButterKit"
  desc "App Store screenshots editor"
  homepage "https://butterkit.app/"

  livecheck do
    url "https://butterkit.app/updates/appcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: ">= :sequoia"

  app "ButterKit-Direct-#{version}-macOS.app", target: "ButterKit.app"

  zap trash: [
    "~/Library/Application Scripts/app.butterkit.direct",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/app.butterkit.direct.sfl*",
    "~/Library/Caches/app.butterkit.direct",
    "~/Library/Containers/app.butterkit.direct",
  ]
end