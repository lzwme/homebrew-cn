class DoubleTrouble < Formula
  desc "Scans directories for duplicate files"
  homepage "https://web.archive.org/web/20040624080055/http://folk.uio.no/vidarsk/"
  url "https://ghproxy.com/https://github.com/nicerloop/doubletrouble/releases/download/v0.90/DoubleTrouble_0.90.jar"
  sha256 "c38766806c717093610bb73f9c23218bc430c4b6bdb20b3e99910c5c9d1a454c"

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    Pathname.glob("#{libexec}/*.jar") do |file|
      bin.write_jar_script file, "double-trouble"
    end
  end
end