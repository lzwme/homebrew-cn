class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20240711.tar.gz"
  sha256 "cfedac09db9086acad55e7a3a0d224068f74b4c011c5b64ad71f1d8680878ce0"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2862da9122af67d7f65b8c99a9818c3a441e109a7cb70e391ef9cc6344c2b6a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0cbed20904c1ef7f933d141decc454c34a2d7b9da84f802239d3b614d2ea771"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb3c8030e9406c738418fc9ba4a2fadfa174768325927b937710058a5d820ea0"
    sha256                               sonoma:         "ac6fca09f4a3b7af67d50e21dd2afb9d5670670da8e667ecafec5dc09020143b"
    sha256                               ventura:        "02b890d6a8ca35617fcc5f6077f14f9c5f9c0888e6ce38d63b65ee18d405c7b4"
    sha256                               monterey:       "9ab85f0e65e327aa7fe35609e54892917e69fd9ea29dcb29d019bb31ecea937a"
    sha256                               x86_64_linux:   "4f26d03e2f2b632008fb66c84de8dab7087e99cd0256828df6385aee26a0c3c2"
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