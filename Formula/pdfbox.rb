class Pdfbox < Formula
  desc "Open source Java tool for working with PDF documents"
  homepage "https://pdfbox.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/pdfbox/3.0.5/pdfbox-app-3.0.5.jar"
  mirror "https://archive.apache.org/dist/pdfbox/3.0.5/pdfbox-app-3.0.5.jar"
  sha256 "d076467fd02214ebc7b5b9d5b3b9ac0891ef768168114ed8a4811b5d16606285"

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    Pathname.glob("#{libexec}/*.jar") do |file|
      bin.write_jar_script file, "pdfbox"
    end
  end
end