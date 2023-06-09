class Rups < Formula
  desc "PDF Diagnostic Tool for Reading and Updating PDF Syntax & Debugging PDF code"
  homepage "https://itextpdf.com/products/rups"
  url "https://ghproxy.com/https://github.com/itext/i7j-rups/releases/download/7.2.5/iText7-RUPS-7.2.5-only-jars.zip"
  sha256 "509e81cbe629b331a80e9344a11fe573e6e4e065c4319c1532ac175da9af5dec"

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