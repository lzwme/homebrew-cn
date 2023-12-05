class Pdfbox < Formula
  desc "Open source Java tool for working with PDF documents"
  homepage "https://pdfbox.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/pdfbox/3.0.1/pdfbox-app-3.0.1.jar"
  mirror "https://archive.apache.org/dist/pdfbox/3.0.1/pdfbox-app-3.0.1.jar"
  sha256 "ab192ac7e0c03e5f58f12d2b130015c9f58d781bc312a940b6c47a7993e4a47e"

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    Pathname.glob("#{libexec}/*.jar") do |file|
      bin.write_jar_script file, "pdfbox"
    end
  end
end