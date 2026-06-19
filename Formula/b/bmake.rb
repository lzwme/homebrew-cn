class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20260609.tar.gz"
  sha256 "213c8cecb955b3307bffc3a8445a327aa3cbc725bf388d3df139df90f2c0d541"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "257d521be4d843eabb4999217bedff30083ee2ca82a2d255a316dd0e64e98612"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82728d004826bbfe80eb6ac717509d3c7fe1b14772d474326b3401f8935c3658"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d4925d3dd8ff7cfcdfedd06843e59001b0f129c598b4e76cfba02f01ba50d1f"
    sha256                               sonoma:        "3be3b9f0db71454c1b2c8de0d74c151d220d5cbe1a1a8fec594ff2005378567d"
    sha256                               arm64_linux:   "c21a154e7f1ddf11c0609d76c94f965f5a660e1b3480deaa491a472c3e3fe282"
    sha256                               x86_64_linux:  "a64d6059e2a639b46da3d68cbdd0ca485d76da23fb67b04b38efa38472125eec"
  end

  uses_from_macos "bc-gh" => :build

  def install
    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    # shell-ksh test segfaults since macOS 11.
    args = ["--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install", "BROKEN_TESTS=shell-ksh"]
    system "sh", "boot-strap", *args

    man1.install "bmake.1"
  end

  test do
    (testpath/"Makefile").write <<~MAKE
      all: hello

      hello:
      	@echo 'Test successful.'

      clean:
      	rm -rf Makefile
    MAKE
    system bin/"bmake"
    system bin/"bmake", "clean"
  end
end