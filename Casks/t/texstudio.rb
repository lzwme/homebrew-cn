cask "texstudio" do
  version "4.8.1"
  sha256 arm:   "af95ac31d9edab7c0d9d100276f14b1368a233b242f0754ca2235872ed5feb0f",
         intel: "9e547180b3013624a61ea5dbc92deac64ed6573d217f6044ccdf0b442932d513"

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