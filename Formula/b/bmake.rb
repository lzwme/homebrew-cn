class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20240909.tar.gz"
  sha256 "d4e019e26c64cc8ffcf1cae9bb04fbb13da8fa6f41fb30fd26e221f655d4e84d"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b32e6100aeabc654941712b475dbd946a219ac92cf4de0dc0b0eb698a8ae884e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d48188692fb0fbca7494cf286d201719961951968aeb6fa607b9870c0b16e503"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e667b4063d2801fb3d557dc724328331f8640faa53bc5f7f260615a99a904e0"
    sha256                               sonoma:        "5b0f1a3acaa654739765d87c9d29a68eaa12ac1d0b8be5e17eb66dbb9f6b8ad0"
    sha256                               ventura:       "6a2180e8d58096a845967a153659a4f15f2b6c948e975636d6da6e591bcdacca"
    sha256                               x86_64_linux:  "83403deef7acb0e26e364017440954f556e6e52f0fa3f593a20f9552394fa1b6"
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
    (testpath/"Makefile").write <<~EOS
      all: hello

      hello:
      \t@echo 'Test successful.'

      clean:
      \trm -rf Makefile
    EOS
    system bin/"bmake"
    system bin/"bmake", "clean"
  end
end