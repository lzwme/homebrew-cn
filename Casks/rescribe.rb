cask "rescribe" do
  version "1.3.0"
  sha256 "d22a4e9baf82c7b03e31b7c211d97299d294fdf2714889622c35d8a49c6f2382"

  url "https:rescribe.xyzrescribe#{version}darwinrescribe.zip"
  name "rescribe"
  desc "Desktop tool for performing OCR on image files, PDFs and Google Books"
  homepage "https:rescribe.xyzrescribe"

  livecheck do
    url "https:github.comrescribebookpipeline"
    strategy :git
  end

  app "Rescribe.app"
end