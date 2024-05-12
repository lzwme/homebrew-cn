cask "texstudio" do
  version "4.8.0"
  sha256 arm:   "d9f972ef2c91191279b5cebab598f9c5633d8feca60d14b708735a8152125915",
         intel: "015f8991ac54ba405e39bf42ae4144feae6a349a057d8a6eba6246c9ff005aea"

  on_arm do
    url "https:github.comtexstudio-orgtexstudioreleasesdownload#{version}texstudio-#{version}-osx-m1.zip",
        verified: "github.comtexstudio-orgtexstudio"

    app "texstudio-#{version}-osx-m1.app"
  end
  on_intel do
    url "https:github.comtexstudio-orgtexstudioreleasesdownload#{version}texstudio-#{version}-osx.dmg",
        verified: "github.comtexstudio-orgtexstudio"

    app "texstudio.app"
  end

  name "TeXstudio"
  desc "LaTeX editor"
  homepage "https:texstudio.org"

  depends_on macos: ">= :big_sur"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentstexstudio.sfl*",
    "~LibraryPreferencestexstudio.plist",
    "~LibrarySaved Application Statetexstudio.savedState",
  ]
end