class Rups < Formula
  desc "PDF Diagnostic Tool for Reading and Updating PDF Syntax & Debugging PDF code"
  homepage "https://itextpdf.com/products/rups"
  # url "https://ghproxy.com/https://github.com/itext/i7j-rups/releases/download/7.2.4/iText7-RUPS-7.2.4-only-jars.zip"
  url "https://repo.itextsupport.com/artifactory/releases/com/itextpdf/itext-rups/7.2.5/itext-rups-7.2.5.jar"
  sha256 "39da23a0d2e40468937c0792e814e72c42a4c28fedfdd05fc154dfaef0c12ed3"

  livecheck do
    strategy :git
    url "https://github.com/itext/i7j-rups.git"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    Pathname.glob("#{libexec}/*.jar") do |file|
      bin.write_jar_script file, "rups"
    end
  end
end