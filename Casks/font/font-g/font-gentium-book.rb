cask "font-gentium-book" do
  version "7.000"
  sha256 "fa4e35bcea62dd68befabf4bb7c2765aacd2691f51ec8ae008f5f913ef49f419"

  url "https:github.comsilnrsifont-gentiumreleasesdownloadv#{version}GentiumBook-#{version}.zip",
      verified: "github.comsilnrsifont-gentium"
  name "Gentium Book"
  homepage "https:software.sil.orggentium"

  no_autobump! because: :requires_manual_review

  font "GentiumBook-#{version}GentiumBook-Bold.ttf"
  font "GentiumBook-#{version}GentiumBook-BoldItalic.ttf"
  font "GentiumBook-#{version}GentiumBook-Italic.ttf"
  font "GentiumBook-#{version}GentiumBook-Medium.ttf"
  font "GentiumBook-#{version}GentiumBook-MediumItalic.ttf"
  font "GentiumBook-#{version}GentiumBook-Regular.ttf"
  font "GentiumBook-#{version}GentiumBook-SemiBold.ttf"
  font "GentiumBook-#{version}GentiumBook-SemiBoldItalic.ttf"

  # No zap stanza required
end