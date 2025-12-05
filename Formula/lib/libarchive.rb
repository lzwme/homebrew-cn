class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.8.4.tar.xz"
  sha256 "c7b847b57feacf5e182f4d14dd6cae545ac6843d55cb725f58e107cdf1c9ad73"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?libarchive[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "962f0d32692bffb1f2124d87afd4c710178a64afb99f529f905266dcd76aa4c8"
    sha256 cellar: :any,                 arm64_sequoia: "851cc0b5f65fcbd0998e40b2a8929675f9d929253ad759a3824369b2e9852936"
    sha256 cellar: :any,                 arm64_sonoma:  "1d0dc0839e689b5bc67fcdba5e73bbd38354068e08d0f676e7ed368d9851c88c"
    sha256 cellar: :any,                 sonoma:        "62c839af1bd97dd11f5697d7719d34b6318866726ec63a314ff50f275e26e514"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2d5d7b1b40ddf36754cc9beca5c140a7796d1cb8e65cec63fb3efe3b4c680ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f650dff84d68c370b356e3c89488ab6002b877f0fc08da5f9fe6d3fcbd3b868d"
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