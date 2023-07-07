class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.0.5.tgz"
  mirror "http://chuck.stanford.edu/release/files/chuck-1.5.0.5.tgz"
  sha256 "c7719b42b26942715c24ecc661ce5fa8ee0cd7c30b333dd16fe7284b006fdbf3"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af75c03dfabcedc89bc120faf2012e51b54c3e17fee560f9b0e58d97cda85f04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6f7d03d09aaad64996ff9f639115cfb929ef839566fa4778686527119bfa6b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5bd1b8c7fffe8b6304cae163e076c1ce2e5d58003545b1a75f679b08616a20f9"
    sha256 cellar: :any_skip_relocation, ventura:        "a4ece5fefd8c391bce22c61d1d262a5619425f4ccdee1d7ee4ed3bb807e9766a"
    sha256 cellar: :any_skip_relocation, monterey:       "cb60e9f9017a79c6c671b611de1e25c69f020f8afa66590da21239e4450b4f82"
    sha256 cellar: :any_skip_relocation, big_sur:        "83b72209421eec1434621c06191903dd72336be1de59f4a81832811b576e4b5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68dc20c3f76f7e2b5f0cf2286c8d998edb08632f521e0047f36ed4b6f9451d8b"
  end

  depends_on xcode: :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "pulseaudio"
  end

  def install
    os = OS.mac? ? "mac" : "linux-pulse"
    system "make", "-C", "src", os
    bin.install "src/chuck"
    pkgshare.install "examples"
  end

  test do
    assert_match "device", shell_output("#{bin}/chuck --probe 2>&1")
  end
end