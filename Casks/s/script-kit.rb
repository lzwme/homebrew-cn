cask "script-kit" do
  arch arm: "arm64", intel: "x64"

  version "3.45.1"
  sha256 arm:   "b6bf54b40525e70f90a01b84653c808b1fd8ca4eb2eeedd7097c060ccc3aaf2b",
         intel: "65d652534e69b49cb795c0ccceb97952ab54121cc98e6c1d1c3acdc833e6b84d"

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