cask "sublime-merge" do
  version "2091"
  sha256 "9d65877c74196f213d0e84c64f2a2b91476be786faf54a4c1cef76b15e67a873"

  url "https://download.sublimetext.com/sublime_merge_build_#{version}_mac.zip",
      verified: "download.sublimetext.com/"
  name "Sublime Merge"
  desc "Git client"
  homepage "https://www.sublimemerge.com/"

  livecheck do
    url "https://www.sublimemerge.com/updates/stable_update_check"
    regex(/"latest_version":\s*(\d+)/i)
  end

  auto_updates true
  conflicts_with cask: "homebrew/cask-versions/sublime-merge-dev"

  app "Sublime Merge.app"
  binary "#{appdir}/Sublime Merge.app/Contents/SharedSupport/bin/smerge"

  uninstall quit: "com.sublimemerge"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.sublimemerge.sfl*",
    "~/Library/Application Support/Sublime Merge",
    "~/Library/Caches/com.sublimemerge/",
    "~/Library/Preferences/com.sublimemerge.plist",
    "~/Library/Saved Application State/com.sublimemerge.savedState",
  ]
end