cask "rescribe" do
  version "1.1.0"
  sha256 "7500b6ff1c76d59f225f81d3bcfeacefdd61bd9c2925673ae644034e1bc14fdf"

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