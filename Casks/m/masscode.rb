cask "masscode" do
  arch arm: "-arm64"

  version "3.12.0"
  sha256 arm:   "debc329c0d01d0b3213d39170fa1363422dda732ac0e7d7b9967fc4f7d315943",
         intel: "54ed1eb5c11667afde667243dac4d7cd9edf31db64380cd30ff94db75683bde0"

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