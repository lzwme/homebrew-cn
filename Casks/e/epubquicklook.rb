cask "epubquicklook" do
  version "1.8"
  sha256 "923b2ebcbffc4ee1da42550c2239b41bad088d61956b22b1a92b293329ef6fe5"

  url "https://ghfast.top/https://github.com/jaketmp/ePub-quicklook/releases/download/v#{version}/epub.qlgenerator.zip"
  name "EPUB QuickLook"
  desc "Quick Look generator and Spotlight importer"
  homepage "https://github.com/jaketmp/ePub-quicklook"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-10-27", because: :unmaintained

  depends_on macos: "<= :high_sierra"

  qlplugin "epub.qlgenerator"
end