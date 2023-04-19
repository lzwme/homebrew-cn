class Hfsprescue < Formula
  desc "Is a program to recover files from a HFS+ formatted partition"
  homepage "https://www.plop.at/en/hfsprescue/index.html"
  url "https://download.plop.at/hfsprescue/hfsprescue-3.6-precompiled.tar.gz"
  version "3.6"
  sha256 "8a0e3bc84c09a8a079cd5ccc43da6addda1170e72bc5b631bc689b81e207bde4"

  livecheck do
    url "https://www.plop.at/en/hfsprescue/intro.html"
    regex(/Latest version: (\d+(?:\.\d+)+),/i)
    strategy :page_match
  end

  def install
    libexec.install Dir["*"]
    bin.install Dir[libexec/"MacOSX/hfsprescue"]
  end

  test do
    system hfsprescue "-v"
  end
end