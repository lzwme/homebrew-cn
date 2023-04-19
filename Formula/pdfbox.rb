class Pdfbox < Formula
  desc "Open source Java tool for working with PDF documents"
  homepage "https://pdfbox.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/pdfbox/2.0.28/pdfbox-app-2.0.28.jar"
  mirror "https://archive.apache.org/dist/pdfbox/2.0.28/pdfbox-app-2.0.28.jar"
  sha256 "9189b28560efad83c52cbcfec368036169b2aa541488632200eec3fc32f5b111"

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    Pathname.glob("#{libexec}/*.jar") do |file|
      bin.write_jar_script file, "pdfbox"
    end
  end
end