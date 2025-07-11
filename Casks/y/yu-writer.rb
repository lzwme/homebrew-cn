cask "yu-writer" do
  version "0.5.3"
  sha256 "4fff4042c6ac7c047097c5e6d59a8a1c3f9dacfbdcadb3121904426413b38e06"

  url "https://ghfast.top/https://github.com/ivarptr/yu-writer.site/releases/download/v#{version}/yu-writer-beta-#{version}-macos.dmg",
      verified: "github.com/ivarptr/yu-writer.site/"
  name "Yu Writer"
  desc "Markdown editor"
  homepage "https://ivarptr.github.io/yu-writer.site/"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "Yu Writer.app"

  zap trash: [
    "~/Library/Application Support/Yu Writer",
    "~/Library/Caches/Yu Writer",
    "~/Library/Preferences/com.github.yu-writer.helper.plist",
    "~/Library/Preferences/com.github.yu-writer.plist",
  ]
end