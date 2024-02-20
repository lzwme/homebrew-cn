cask "masscode" do
  arch arm: "-arm64"

  version "3.11.0"
  sha256 arm:   "0738f53fac8d159a1602cb14f2ff296e97f77736afe8e8bdb4dda40887c76eaa",
         intel: "5b916e3a14d6df1699703d82558f179a5bb1fd0258c8ca05a4412ab1136f3cb9"

  url "https:github.commassCodeIOmassCodereleasesdownloadv#{version}massCode-#{version}#{arch}.dmg",
      verified: "github.commassCodeIOmassCode"
  name "massCode"
  desc "Code snippets manager for developers"
  homepage "https:masscode.io"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  app "massCode.app"

  zap trash: [
        "~LibraryApplication SupportmassCode",
        "~LibraryPreferencesio.masscode.app.plist",
        "~LibrarySaved Application Stateio.masscode.app.savedState",
      ],
      rmdir: "~massCode"
end