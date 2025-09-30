cask "texifier" do
  version "1.9.32,850,743258d"
  sha256 "a277c26c744a4d514f9f21bb57b06b61d9d5d9fa2a937553fa6523fbccc9a67a"

  url "https://download.texifier.com/apps/osx/updates/Texifier_#{version.csv.first.dots_to_underscores}__#{version.csv.second}__#{version.csv.third}.dmg"
  name "Texifier"
  desc "LaTeX editor"
  homepage "https://www.texifier.com/mac"

  livecheck do
    url "https://www.texifier.com/apps/updates/texifier/appcast-stable.xml"
    regex(/Texifier[._-]v?(\d+(?:[._]\d+)+)__(\d+)__(\h+)\.dmg/i)
    strategy :sparkle do |item, regex|
      match = item.url.match(regex)
      next if match.blank?

      "#{match[1].tr("_", ".")},#{match[2]},#{match[3]}"
    end
  end

  auto_updates true
  depends_on macos: ">= :sonoma"

  app "Texifier.app"

  zap trash: [
    "~/Library/Application Support/CloudDocs/session/containers/iCloud.com.vallettaventures.texpadm",
    "~/Library/Application Support/CloudDocs/session/containers/iCloud.com.vallettaventures.texpadm.plist",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.vallettaventures.texpad.sfl*",
    "~/Library/Application Support/Texpad",
    "~/Library/Caches/com.vallettaventures.Texpad",
    "~/Library/Cookies/com.vallettaventures.Texpad.binarycookies",
    "~/Library/HTTPStorages/com.vallettaventures.Texpad",
    "~/Library/HTTPStorages/com.vallettaventures.Texpad.binarycookies",
    "~/Library/Preferences/com.vallettaventures.Texpad.plist",
    "~/Library/Saved Application State/com.vallettaventures.Texpad.savedState",
    "~/Library/WebKit/com.vallettaventures.Texpad",
  ]
end