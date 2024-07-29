cask "pdfshaver" do
  version "1.0"
  sha256 "ebfacb5e30b0939c4549f36fe88be10c0d4bae1ffaa4616e70daf849d19df9d0"

  url "https:github.comtparryPDFShaver.appreleasesdownloadv#{version}PDFShaver.zip"
  name "PDFShaver"
  desc "Shrink PDF files to make them smaller"
  homepage "https:github.comtparryPDFShaver.app"

  deprecate! date: "2024-07-28", because: :unmaintained

  app "PDFShaver.app"

  zap trash: [
    "~LibraryPreferencescom.tparry.PDFShaver.plist",
    "~LibrarySaved Application Statecom.tparry.PDFShaver.savedState",
  ]

  caveats do
    requires_rosetta
  end
end