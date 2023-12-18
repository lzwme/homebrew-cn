class PdfStripWatermark < Formula
  desc "Strip text-based watermarks from PDF files"
  homepage "https:github.comthebabushpdf-strip-watermark"
  url "https:github.comthebabushpdf-strip-watermarkrawmasterpdf-strip-watermark-0.3-all.jar"
  sha256 "02f957c49c02ac2745b46d4f829e24f6dae70fbc7744ecb43b92c6952e58fa7d"

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    Pathname.glob("#{libexec}*.jar") do |file|
      bin.write_jar_script file, "pdf-strip-watermark"
    end
  end
end