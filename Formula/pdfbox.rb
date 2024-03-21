class Pdfbox < Formula
  desc "Open source Java tool for working with PDF documents"
  homepage "https://pdfbox.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/pdfbox/3.0.2/pdfbox-app-3.0.2.jar"
  mirror "https://archive.apache.org/dist/pdfbox/3.0.2/pdfbox-app-3.0.2.jar"
  sha256 "88555c86353f4fb178f83699acd50c79a1f6dcfaa695776cac1320cec3066311"

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    Pathname.glob("#{libexec}/*.jar") do |file|
      bin.write_jar_script file, "pdfbox"
    end
  end
end