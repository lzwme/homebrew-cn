cask "ipepresenter" do
  arch arm: "arm", intel: "intel"

  version "7.2.29"
  sha256 arm:   "bf72ed043b3cb914b3f43ba9abc376fabdee873c557d999b7d968a23ea4a5b8b",
         intel: "908c08046f01ae3c8a0a6b1af95c95b330739bcf47f12654acb266e03917a9a7"

  url "https:github.comotfriedipereleasesdownloadv#{version}ipepresenter-#{version}-mac-#{arch}.dmg",
      verified: "github.comotfriedipe"
  name "IpePresenter"
  desc "Make presentations from PDFs"
  homepage "https:ipepresenter.otfried.org"

  livecheck do
    url :homepage
    regex(href=.*?ipepresenter[._-](\d+(?:\.\d+)+)[._-]mac[._-]#{arch}\.dmgi)
  end

  no_autobump! because: :requires_manual_review

  app "IpePresenter.app"

  zap trash: [
    "~LibraryPreferencesorg.otfried.ipe.IpePresenter.plist",
    "~LibrarySaved Application Stateorg.otfried.ipe.IpePresenter.savedState",
  ]
end