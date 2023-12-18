cask "ipepresenter" do
  arch arm: "arm", intel: "intel"

  version "7.2.28"
  sha256 arm:   "1344f1fb01da20443fc2acc48fe8a90fec76b790d71a6b022c2ddb45db9aa4a2",
         intel: "de4317a02ea6a2b93a5f49aa0e61876de647160cfe3286ae573f89828353e697"

  url "https:github.comotfriedipereleasesdownloadv#{version}ipepresenter-#{version}-mac-#{arch}.dmg",
      verified: "github.comotfriedipe"
  name "IpePresenter"
  desc "Make presentations from PDFs"
  homepage "https:ipepresenter.otfried.org"

  livecheck do
    url :homepage
    regex(href=.*?ipepresenter[._-](\d+(?:\.\d+)+)[._-]mac[._-]#{arch}\.dmgi)
  end

  app "IpePresenter.app"
end