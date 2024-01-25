cask "masscode" do
  arch arm: "-arm64"

  version "3.10.0"
  sha256 arm:   "e5f50023d2f3cfeafce1b79036703fbfb745c56ccb977bb073d45e2a2fa2a05f",
         intel: "cbf4cfbcbb448582d00ed91b5ae8ea94531c31ce1fdb3368a26ee65fccf7ceea"

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