cask "texstudio" do
  version "4.7.3"
  sha256 arm:   "314da45d6071c4e18643282b25f6df7114bd42964d85b63526ffbfa048d993e7",
         intel: "ce1cd5ab82d907165e232dfc5ccf8329f086e375f4936c6b9da9b0091ddd0674"

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