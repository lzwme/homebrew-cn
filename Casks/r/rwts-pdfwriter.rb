cask "rwts-pdfwriter" do
  version "3.1a"
  sha256 "ddf4801fec6aceb81e98f88799cfbc8ef2499c48643638210a629a0d5f9bf6c2"

  url "https:github.comrodyagerRWTS-PDFwriterreleasesdownloadv#{version}RWTS-PDFwriter.pkg"
  name "RWTS PDFwriter"
  desc "Print driver for printing documents directly to a pdf file"
  homepage "https:github.comrodyagerRWTS-PDFwriter"

  no_autobump! because: :requires_manual_review

  pkg "RWTS-PDFwriter.pkg"

  uninstall script: {
    executable: "LibraryPrintersRWTSPDFwriteruninstall",
    sudo:       true,
  }

  # No zap stanza required
end