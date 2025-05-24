cask "texstudio" do
  version "4.8.7"

  on_ventura :or_older do
    sha256 "4f325c3bf10e0f63e8b4fb46d5c2a7362060dbfbae63148af49ae337b780f752"

    caveats do
      requires_rosetta
    end
  end
  on_sonoma :or_newer do
    arch arm: "-m1"

    sha256 arm:   "73c7195d4ae56bf1b5757012cff3b87ccce885c427c1233c2d584b641172a023",
           intel: "4f325c3bf10e0f63e8b4fb46d5c2a7362060dbfbae63148af49ae337b780f752"
  end

  url "https:github.comtexstudio-orgtexstudioreleasesdownload#{version}texstudio-#{version}-osx#{arch}.zip",
      verified: "github.comtexstudio-orgtexstudio"
  name "TeXstudio"
  desc "LaTeX editor"
  homepage "https:texstudio.org"

  depends_on macos: ">= :big_sur"

  app "texstudio-#{version}-osx#{arch}.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentstexstudio.sfl*",
    "~LibraryPreferencestexstudio.plist",
    "~LibrarySaved Application Statetexstudio.savedState",
  ]
end