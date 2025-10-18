class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.8.2.tar.xz"
  sha256 "db0dee91561cbd957689036a3a71281efefd131d35d1d98ebbc32720e4da58e2"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?libarchive[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0a3a9a4c056ddcdb96946e7c773fb5b771c40ed36096008fbb3e5ed19b8b66b6"
    sha256 cellar: :any,                 arm64_sequoia: "c70fe23fc30fec7110789f54417155f8c0c6d033668e6b1edbd25543ff31d27d"
    sha256 cellar: :any,                 arm64_sonoma:  "e3b83193c61506fd9a5553bc89727d9a715e46f0ccb7d31952f35c5237cb09b5"
    sha256 cellar: :any,                 sonoma:        "93a051b1fc9b0bb44b2cec5f4af61659b51c349bb24b95dfeacf9a3c4a1850b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10f151984f3b6b7b59774659e930900da4170ee604269231d842eee083d435cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5d4dda2d93270fb1855a90351014b20327a9e203f6c967b1a66031593fdfc6d"
  end

  keg_only :provided_by_macos

  depends_on "libb2"
  depends_on "lz4"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args,
           "--without-lzo2",    # Use lzop binary instead of lzo2 due to GPL
           "--without-nettle",  # xar hashing option but GPLv3
           "--without-xml2",    # xar hashing option but tricky dependencies
           "--without-openssl", # mtree hashing now possible without OpenSSL
           "--with-expat"       # best xar hashing option

    system "make", "install"

    # Avoid hardcoding Cellar paths in dependents.
    inreplace lib/"pkgconfig/libarchive.pc", prefix.to_s, opt_prefix.to_s

    return unless OS.mac?

    # Just as apple does it.
    ln_s bin/"bsdtar", bin/"tar"
    ln_s bin/"bsdcpio", bin/"cpio"
    ln_s man1/"bsdtar.1", man1/"tar.1"
    ln_s man1/"bsdcpio.1", man1/"cpio.1"
  end

  test do
    (testpath/"test").write("test")
    system bin/"bsdtar", "-czvf", "test.tar.gz", "test"
    assert_match "test", shell_output("#{bin}/bsdtar -xOzf test.tar.gz")
  end
end