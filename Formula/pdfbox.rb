class Pdfbox < Formula
  desc "Open source Java tool for working with PDF documents"
  homepage "https://pdfbox.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/pdfbox/2.0.27/pdfbox-app-2.0.27.jar"
  mirror "https://archive.apache.org/dist/pdfbox/2.0.27/pdfbox-app-2.0.27.jar"
  sha256 "2c9e46fdc92328361b21b04921f3bd26435b4c472234e283bce278f66c4c2fbc"

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    Pathname.glob("#{libexec}/*.jar") do |file|
      bin.write_jar_script file, "pdfbox"
    end
  end
end