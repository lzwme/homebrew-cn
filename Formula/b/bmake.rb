class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20250528.tar.gz"
  sha256 "0dc389a5e0298aa585353b60796d5d632de660dade58d00acd60ad722846c9a3"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a83f78f8861a49fd73773e1bf22b90e598811cfc1dda39aec433b48109acadfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af14fc3b9f056b85ef7814fdd64c35c51a758f65c62b9778a4387297b2abd647"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13464297ea400c6fa8da53ef4b78aa959a4b35b0b450526362eef16f30b511af"
    sha256                               sonoma:        "9a7bcc0516479d7e60f7f32e3d5edb53880f5afb5f538ac1f5c48e16cbe74695"
    sha256                               ventura:       "b25cdc426784aa7a332445ee5ed42caf0720836665264ff7376adb47d463904f"
    sha256                               arm64_linux:   "64d479442313687c9fb57a95cb516ab574b25d92086ee0d99e6df919eaba049a"
    sha256                               x86_64_linux:  "b45148179ad8690da3e52df18ca235ff7f494ea7f50c743451d73d0ef98967c9"
  end

  uses_from_macos "bc" => :build

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