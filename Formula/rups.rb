class Rups < Formula
  desc "PDF Diagnostic Tool for Reading and Updating PDF Syntax & Debugging PDF code"
  homepage "https://itextpdf.com/products/rups"
  url "https://ghfast.top/https://github.com/itext/rups/releases/download/25.03/iText-RUPS-25.03-only-jars.zip"
  sha256 "6c3da33137ec3a0e76df60c6c3fa7e0ea66218fa0c3c61a6d92b8d3c3f182840"

  livecheck do
    strategy :github_latest
    url "https://github.com/itext/rups.git"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    Pathname.glob("#{libexec}/*.jar") do |file|
      bin.write_jar_script file, "rups"
    end
  end
end