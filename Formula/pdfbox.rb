class Pdfbox < Formula
  desc "Open source Java tool for working with PDF documents"
  homepage "https://pdfbox.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/pdfbox/2.0.29/pdfbox-app-2.0.29.jar"
  mirror "https://archive.apache.org/dist/pdfbox/2.0.29/pdfbox-app-2.0.29.jar"
  sha256 "d2c7a8e03d0ac8ac297a1a70a612a126bee95a8e690ff3e4780f670cec1b4d23"

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    Pathname.glob("#{libexec}/*.jar") do |file|
      bin.write_jar_script file, "pdfbox"
    end
  end
end