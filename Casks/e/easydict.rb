cask "easydict" do
  version "2.14.1"
  sha256 "42b8d168fbbcbd45c330978f377e26d1a23822ce134627c9edb082736125a3c3"

  url "https://ghfast.top/https://github.com/tisfeng/Easydict/releases/download/#{version}/Easydict.dmg"
  name "Easydict"
  desc "Dictionary and translator app"
  homepage "https://github.com/tisfeng/Easydict/"

  livecheck do
    url "https://ghfast.top/https://raw.githubusercontent.com/tisfeng/Easydict/main/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "Easydict.app"

  zap trash: [
    "~/Library/Application Support/com.izual.Easydict",
    "~/Library/Caches/com.izual.Easydict",
    "~/Library/Caches/com.plausiblelabs.crashreporter.data/com.izual.Easydict",
    "~/Library/HTTPStorages/com.izual.Easydict",
    "~/Library/HTTPStorages/com.izual.Easydict.binarycookies",
    "~/Library/Preferences/com.izual.Easydict.plist",
    "~/Library/WebKit/com.izual.Easydict",
  ]
end