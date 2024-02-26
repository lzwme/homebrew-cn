cask "rescribe" do
  version "1.2.0"
  sha256 "cf4f2dae0349637b4e7fba24fcab3895af7407e94e9a881fbe4a2c87aba69cdf"

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