cask "texstudio" do
  arch arm: "-m1"

  version "4.8.7"
  sha256 arm:   "73c7195d4ae56bf1b5757012cff3b87ccce885c427c1233c2d584b641172a023",
         intel: "4f325c3bf10e0f63e8b4fb46d5c2a7362060dbfbae63148af49ae337b780f752"

  on_arm do
    depends_on macos: ">= :sonoma"
  end
  on_intel do
    depends_on macos: ">= :big_sur"
  end

  url "https:github.comtexstudio-orgtexstudioreleasesdownload#{version}texstudio-#{version}-osx#{arch}.zip",
      verified: "github.comtexstudio-orgtexstudio"
  name "TeXstudio"
  desc "LaTeX editor"
  homepage "https:texstudio.org"

  app "texstudio-#{version}-osx#{arch}.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentstexstudio.sfl*",
    "~LibraryPreferencestexstudio.plist",
    "~LibrarySaved Application Statetexstudio.savedState",
  ]
end