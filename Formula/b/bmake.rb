class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20240508.tar.gz"
  sha256 "847a20f03e6f2ee26b9f7cf8db4a353120540686daa565e2ec6ff800317ddaab"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5981fea4f6d0eefc28a31a889df595313dc26d78731aaf7faaefcc1a6b763add"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "750a273031723fea905c2b92c403b6cd1c4372290a381ac41f6534abf6507677"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "000fb67c532904d9c8d46a46878677743b7c6d61a815b97d0d13c9368f4eb60d"
    sha256                               sonoma:         "1d61fb0ebf7bde8dce2c83e8e54d0cbbf5b67869b93823f1b654e75122a11b5b"
    sha256                               ventura:        "2e5469ee7b6fb6ab95e26e1ff121d75d01dd98e829230b0c141e048b4253a3ac"
    sha256                               monterey:       "d6c4db2d80e4f0d7a9f8d533950afc18ee101b3f8f7399898419b6d8cff7c05f"
    sha256                               x86_64_linux:   "181e107f1919427e5e8edde70d92456c170855a36f4bbb410442830df4d67a17"
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