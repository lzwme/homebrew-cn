class Pdfbox < Formula
  desc "Open source Java tool for working with PDF documents"
  homepage "https://pdfbox.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/pdfbox/3.0.0/pdfbox-app-3.0.0.jar"
  mirror "https://archive.apache.org/dist/pdfbox/3.0.0/pdfbox-app-3.0.0.jar"
  sha256 "1e5211dc668355510d332ea094ad91616fa8d8c7451205e8b57a4218bcbcb34e"

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    Pathname.glob("#{libexec}/*.jar") do |file|
      bin.write_jar_script file, "pdfbox"
    end
  end
end