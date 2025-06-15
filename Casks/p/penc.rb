cask "penc" do
  version "1.0.0"
  sha256 "67e53ad3f05031473021676e32b001824d754d757818fd8fd44751462cf3e812"

  url "https:github.comdgurkaynakPencreleasesdownload#{version}Penc-#{version}.dmg",
      verified: "github.comdgurkaynakPenc"
  name "Penc"
  desc "Trackpad-oriented window manager"
  homepage "https:deniz.copenc"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :high_sierra"

  app "Penc.app"

  zap trash: "~LibraryPreferencescom.denizgurkaynak.Penc.plist"
end