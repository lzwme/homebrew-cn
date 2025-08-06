cask "epubmdimporter" do
  version "1.8"
  sha256 "740c288a6ad2c98d5c94cf6eccba3ef535faaeda5ad408a897f84d4b324d16e0"

  url "https://ghfast.top/https://github.com/jaketmp/ePub-quicklook/releases/download/v#{version}/epub.mdimporter.zip"
  name "EPUB Spotlight"
  homepage "https://github.com/jaketmp/ePub-quicklook"

  deprecate! date: "2024-10-13", because: :unmaintained

  mdimporter "epub.mdimporter", target: "AA_epub.mdimporter"
end