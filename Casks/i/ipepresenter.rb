cask "ipepresenter" do
  arch arm: "arm", intel: "intel"

  version "7.2.29"
  sha256 arm:   "bf72ed043b3cb914b3f43ba9abc376fabdee873c557d999b7d968a23ea4a5b8b",
         intel: "908c08046f01ae3c8a0a6b1af95c95b330739bcf47f12654acb266e03917a9a7"

  url "https://ghfast.top/https://github.com/otfried/ipe/releases/download/v#{version}/ipepresenter-#{version}-mac-#{arch}.dmg",
      verified: "github.com/otfried/ipe/"
  name "IpePresenter"
  desc "Make presentations from PDFs"
  homepage "https://ipepresenter.otfried.org/"

  livecheck do
    url :homepage
    regex(/href=.*?ipepresenter[._-](\d+(?:\.\d+)+)[._-]mac[._-]#{arch}\.dmg/i)
  end

  no_autobump! because: :requires_manual_review

  app "IpePresenter.app"

  zap trash: [
    "~/Library/Preferences/org.otfried.ipe.IpePresenter.plist",
    "~/Library/Saved Application State/org.otfried.ipe.IpePresenter.savedState",
  ]
end