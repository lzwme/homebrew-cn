class Reprepro < Formula
  desc "Debian package repository manager"
  homepage "https://salsa.debian.org/debian/reprepro"
  url "https://deb.debian.org/debian/pool/main/r/reprepro/reprepro_5.4.7.orig.tar.xz"
  sha256 "df87e4168a580366cdeb3fdc31c5fa99b7d73140e7a7ca5d85ce64bb25370d6f"
  license "GPL-2.0-only"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/r/reprepro/"
    regex(/href=.*?reprepro[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2844e0a31431948d7695c42943a5eca453e15ecf54d4bd31cbc7cb0863670443"
    sha256 cellar: :any,                 arm64_sequoia: "5146c355e2be811b41d026ae77f5c0d51fcc91d19cbb15a5e0fc4e6b78808834"
    sha256 cellar: :any,                 arm64_sonoma:  "e912a43c8faef1de37effce75d6b5665d5d8039c86e73c1cebf71e9845255b29"
    sha256 cellar: :any,                 sonoma:        "d0894c2657bddb755593ef65724ad0da78d742d26c9092433f6886bad46db64b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d952be54d3928a47d9191c3e9b5218e19fb27c4b38a13c2c1e7a1da5e8383edc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b1f03fb797c16bdea4c00888be000b40ea8c6ef9b8d6f3cc189601093f70d6b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "berkeley-db@5"
  depends_on "gpgme"
  depends_on "libarchive"
  depends_on "libgpg-error"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gcc"
  end

  fails_with :clang do
    cause "No support for GNU C nested functions"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules",
                          "--with-gpgme=#{Formula["gpgme"].opt_lib}",
                          "--with-libarchive=#{Formula["libarchive"].opt_lib}",
                          "--with-libbz2=yes",
                          "--with-liblzma=#{Formula["xz"].opt_lib}",
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