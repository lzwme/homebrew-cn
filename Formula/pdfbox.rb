class Pdfbox < Formula
  desc "Open source Java tool for working with PDF documents"
  homepage "https://pdfbox.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/pdfbox/3.0.4/pdfbox-app-3.0.4.jar"
  mirror "https://archive.apache.org/dist/pdfbox/3.0.4/pdfbox-app-3.0.4.jar"
  sha256 "fba2f689270a75ce730c080ee9070ea6b0a4d16b544bf436f06ccceab5522143"

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    Pathname.glob("#{libexec}/*.jar") do |file|
      bin.write_jar_script file, "pdfbox"
    end
  end
end