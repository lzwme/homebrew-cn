cask "texstudio" do
  arch arm: "-m1", intel: ""

  version "4.8.5"
  sha256 arm:   "dd7b7b2d5918afe10c35ebdb06790b35b72364740faf9e35ef7b78b5dba456fc",
         intel: "1f1925bda6d82003481c1952f8702597dfb71657d2ad774e452af1e9e45036d4"

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