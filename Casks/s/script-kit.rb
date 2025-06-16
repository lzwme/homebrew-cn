cask "script-kit" do
  arch arm: "arm64", intel: "x64"

  version "3.33.0"
  sha256 arm:   "38472da6be808f2692d7569af03abaca920467369c041d4636b86e1da0b2d947",
         intel: "a7d36d1c26ee395b0da0298051bc93cff2c9487ff38ce742210f7cf4ae39d089"

  url "https:github.comjohnlindquistkitappreleasesdownloadv#{version}Script-Kit-macOS-#{version}-#{arch}.dmg",
      verified: "github.comjohnlindquistkitapp"
  name "Script Kit"
  desc "Create and run scripts"
  homepage "https:www.scriptkit.com"

  livecheck do
    url :homepage
    regex(href=.*?Script[._-]Kit[._-]macOS[._-]v?(\d+(?:\.\d+)+)[._-]#{arch}\.dmgi)
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :catalina"

  app "Script Kit.app"

  zap trash: [
    "~.kit",
    "~LibraryApplication SupportKit",
    "~LibraryLogsKit",
  ]
end