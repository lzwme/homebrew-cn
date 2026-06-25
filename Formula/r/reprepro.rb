class Reprepro < Formula
  desc "Debian package repository manager"
  homepage "https://salsa.debian.org/debian/reprepro"
  url "https://deb.debian.org/debian/pool/main/r/reprepro/reprepro_5.5.0.orig.tar.xz"
  sha256 "efc317fba149e40bb7f96251d433ab8bbcffac1c12fe07db1327c6a25a27aac7"
  license "GPL-2.0-only"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/r/reprepro/"
    regex(/href=.*?reprepro[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2f2b25c1d2cdeaf5cac54a2f96eaccd8d96fd07025d402e7c84c5866a1a0f769"
    sha256 cellar: :any, arm64_sequoia: "afb1416cadd36f7ae2f5039116ea17fd09dd871b89b063a2ddbdf6aa9c6ca8b0"
    sha256 cellar: :any, arm64_sonoma:  "a897736d0e1b99fce210a08fe735e2cb6dddd569235005905da2745698798f02"
    sha256 cellar: :any, sonoma:        "655aac8599ed951be2c079a158d5ff0dfedd54b2bd852b6dd1d42d4c3b2e38da"
    sha256 cellar: :any, arm64_linux:   "1bac0c344db85c479c697c85d5c3fa980cc0904bde2a953baa62d0025c46c65b"
    sha256 cellar: :any, x86_64_linux:  "50f78047cddd1e7cbf5d0818e03e066d8fab00569c5c876922c487d734999e03"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "berkeley-db@5" # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1119179
  depends_on "gpgme"
  depends_on "libarchive"
  depends_on "libgpg-error"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"

  on_macos do
    depends_on "gcc"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :clang do
    cause "No support for GNU C nested functions"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules",
                          "--with-gpgme=#{formula_opt_lib("gpgme")}",
                          "--with-libarchive=#{formula_opt_lib("libarchive")}",
                          "--with-libbz2=yes",
                          "--with-liblzma=#{formula_opt_lib("xz")}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"conf/distributions").write <<~EOF
      Codename: test_codename
      Architectures: source
      Components: main
    EOF
    system bin/"reprepro", "-b", testpath, "list", "test_codename"
  end
end