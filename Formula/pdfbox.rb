class Pdfbox < Formula
  desc "Open source Java tool for working with PDF documents"
  homepage "https://pdfbox.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/pdfbox/3.0.3/pdfbox-app-3.0.3.jar"
  mirror "https://archive.apache.org/dist/pdfbox/3.0.3/pdfbox-app-3.0.3.jar"
  sha256 "a0269317c8b72551df695eef4f6cd459895850f122c62b7f10b3f9951cba2ecb"

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    Pathname.glob("#{libexec}/*.jar") do |file|
      bin.write_jar_script file, "pdfbox"
    end
  end
end