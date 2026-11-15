cask "markdown-preview" do
  version "0.0.73"
  sha256 "98881a0223a4413361e3b7ebd128f4f8fc8455685a8c1010415a580c52a59e7a"

  url "https://ghfast.top/https://github.com/pluk-inc/markdown-preview/releases/download/v#{version}/Markdown-Preview.dmg"
  name "Markdown Preview"
  desc "Markdown previewer with bundled Quick Look extension"
  homepage "https://markdownpreview.app/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :sequoia

  app "Markdown Preview.app"
  binary "#{appdir}/Markdown Preview.app/Contents/Resources/bin/markdown-preview", target: "mdp"

  uninstall quit: "doc.md-preview"

  zap trash: [
    "~/Library/Application Scripts/5P3TSMNV42.doc.md-preview",
    "~/Library/Application Scripts/doc.md-preview",
    "~/Library/Application Scripts/doc.md-preview.quick-look",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/doc.md-preview.sfl*",
    "~/Library/Caches/doc.md-preview",
    "~/Library/Containers/doc.md-preview",
    "~/Library/Containers/doc.md-preview.quick-look",
    "~/Library/Group Containers/5P3TSMNV42.doc.md-preview",
    "~/Library/HTTPStorages/doc.md-preview",
    "~/Library/Preferences/doc.md-preview.plist",
  ]
end