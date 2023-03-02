class Hfsprescue < Formula
  desc "Is a program to recover files from a HFS+ formatted partition"
  homepage "https://www.plop.at/en/hfsprescue/index.html"
  url "https://download.plop.at/hfsprescue/hfsprescue-3.5-precompiled.tar.gz"
  version "3.5"
  sha256 "ea78392c6ed352944bf5e32a88ce504257a86da561b796ce49bf719f640f5c00"

  livecheck do
    url "https://www.plop.at/en/hfsprescue/intro.html"
    regex(/Latest version: (3.5),/i)
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