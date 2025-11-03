class Pdfbox < Formula
  desc "Open source Java tool for working with PDF documents"
  homepage "https://pdfbox.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/pdfbox/3.0.6/pdfbox-app-3.0.6.jar"
  mirror "https://archive.apache.org/dist/pdfbox/3.0.6/pdfbox-app-3.0.6.jar"
  sha256 "28948291a7d6addb91a158292f2e9348d2143720e25a9c87c91bbdd4b088475f"

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    Pathname.glob("#{libexec}/*.jar") do |file|
      bin.write_jar_script file, "pdfbox"
    end
  end
end