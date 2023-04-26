class Tradcpp < Formula
  desc "K&R-style C preprocessor"
  homepage "https://www.netbsd.org/~dholland/tradcpp/"
  url "https://cdn.netbsd.org/pub/NetBSD/misc/dholland/tradcpp-0.5.3.tar.gz"
  sha256 "e17b9f42cf74b360d5691bc59fb53f37e41581c45b75fcd64bb965e5e2fe4c5e"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?tradcpp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae50daead4edf3e9669b42267182a9bae1f57720bbeb635e9dcc50341ceb27b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4a656232f875bcb230883e1f5ed126b4a548d0cece88453a487a4e2cfc4dd89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b8d415d6720467f22655633820ca17c596c7eb6c9e4a3251ce0d12c6b0c64b5"
    sha256 cellar: :any_skip_relocation, ventura:        "4655462eea375707576c583c4107442cf648ed1deeebfbd64517b7058717ea66"
    sha256 cellar: :any_skip_relocation, monterey:       "4efcf13b3cf15f4c8013ba1000f424d0a240ba16b8436a086d82a1a29edc7d2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8818618fd35264ceb99df10c17a3af736fd91c886a1db778ad752095631523c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "825a5e3d755cd11ad9e6e7cdb2f5d499cf273b294da1c78a7488535eccad598b"
  end

  depends_on "bmake" => :build

  def install
    bmake_args = %W[
      prefix=#{prefix}
      MK_INSTALL_AS_USER=yes
      MANDIR=#{man}
    ]

    system "bmake"
    system "bmake", *bmake_args, "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #define FOO bar
      FOO
    EOS
    assert_match "bar", shell_output(bin/"tradcpp ./test.c")
  end
end