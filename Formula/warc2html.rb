class Warc2html < Formula
  desc "Converts WARC files to static HTML"
  homepage "https://github.com/iipc/warc2html"
  url "https://ghproxy.com/https://github.com/iipc/warc2html/releases/download/v0.1.0/warc2html-0.1.0.jar"
  sha256 "02f957c49c02ac2745b46d4f829e24f6dae70fbc7744ecb43b92c6952e58fa7d"

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    Pathname.glob("#{libexec}/*.jar") do |file|
      bin.write_jar_script file, "warc2html"
    end
  end
end