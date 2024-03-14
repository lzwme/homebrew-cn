class Jpdftweak < Formula
  desc "Swiss Army Knife GUI application for PDF documents"
  homepage "https://jpdftweak.sourceforge.io"
  url "https://downloads.sourceforge.net/jpdftweak/jpdftweak-compact-1.1.zip"
  sha256 "e8aa3f44bc93a7a0a4d32d500fdc02509608cc2cf5a34942a772a10eec478897"
  license "AGPL-3.0-only"

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    Pathname.glob("#{libexec}/*.jar") do |file|
      bin.write_jar_script file, "jpdftweak"
    end
  end
end