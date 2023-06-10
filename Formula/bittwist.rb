class Bittwist < Formula
  desc "Libcap-based Ethernet packet generator"
  homepage "https://bittwist.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bittwist/macOS/Bit-Twist%203.2/bittwist-macos-3.2.tar.gz"
  sha256 "de6f5449a4e23be37c33f0429b17ec8a5ded611504822d621677bb95fe7a12cd"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d978d2788aa2b68247122810b593398eae384ee8de8d953595a39490aa6ea55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d77bb81d474e27c2efccdd75d06cf5f1179f610d23b2ce8a571d2b52dce58c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bce8fac5206045522a0bf9d05827ab3c999f73c2f0f2115ad2deb5fb51b76020"
    sha256 cellar: :any_skip_relocation, ventura:        "eac3ded832b408891c94042dc62902ff3012e059b4c47d2390dfa280611b9a80"
    sha256 cellar: :any_skip_relocation, monterey:       "d038eaf597396d77f076f21524ed3df68d51de1c7d4d72842e3dd42ff8c560d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "7fdc2daeb7d2dd35d03f6d16feda1c9ca23f14195a343fe8fc5ada41cb1cc389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69bf861ba59b7c7077f87d651d1e19482dd253b02b88dc8d3cb3dc1ead6813cd"
  end

  uses_from_macos "libpcap"

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/bittwist", "-help"
    system "#{bin}/bittwiste", "-help"
  end
end