cask "masscode" do
  arch arm: "-arm64"

  version "3.12.1"
  sha256 arm:   "07935b2d734dd82ea65a977f2b6f388ed2ceb1818c85fbb890bf369f19bd1916",
         intel: "ca1ac865b7aedb8a765799a67927f3b59e623efa9a3fbcafb34a7189ae063b10"

  url "https:github.commassCodeIOmassCodereleasesdownloadv#{version}massCode-#{version}#{arch}.dmg",
      verified: "github.commassCodeIOmassCode"
  name "massCode"
  desc "Code snippets manager for developers"
  homepage "https:masscode.io"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  no_autobump! because: :requires_manual_review

  app "massCode.app"

  zap trash: [
        "~LibraryApplication SupportmassCode",
        "~LibraryPreferencesio.masscode.app.plist",
        "~LibrarySaved Application Stateio.masscode.app.savedState",
      ],
      rmdir: "~massCode"
end