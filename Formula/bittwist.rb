class Bittwist < Formula
  desc "Libcap-based Ethernet packet generator"
  homepage "https://bittwist.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bittwist/macOS/Bit-Twist%203.6/bittwist-macos-3.6.tar.gz"
  sha256 "484339e5672c454aeef7ee834e33acad2d2fc04a4c9a9dc32924c0316a2530dc"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4b05c4345adcc76df701265ded591ff0c0326c636f05666b021453b281da007"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4946ac215b1dbb96b74b09fca7c4fb7c87b682fc1ccf2759fc79cd5b12feba49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25ed29ab59da786104ce0bc213c34eaaa29fd4e008bf1bdd1f963d4817334c37"
    sha256 cellar: :any_skip_relocation, ventura:        "6b1cd3f18cd2137d65e9656ee6f75ff7663cdad7a18a052ee4f218085834851e"
    sha256 cellar: :any_skip_relocation, monterey:       "2225397ddf6e3b493b1257cf1a01a9b732d3dc7f28bb5891fe375b92d9a55dac"
    sha256 cellar: :any_skip_relocation, big_sur:        "a49de0d6f8a5ab2c629895c66bf079f58bdc3cd67bdbc8642c43876bf8c274a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0ac72d1bc5fb5b29d585585120ac3da348ec81b3b2899ee396b6e8ec6f638fa"
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