class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sourceforge.net/project/freetype/freetype2/2.14.3/freetype-2.14.3.tar.xz"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.14.3.tar.xz"
  sha256 "36bc4f1cc413335368ee656c42afca65c5a3987e8768cc28cf11ba775e785a5f"
  license "FTL"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/url=.*?freetype[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "f705e663ae79e8687317afd82ff7f2fd83bf06773b728f98c60eacf57e973f63"
    sha256 cellar: :any, arm64_tahoe:       "12a2e191f4ef6b4fd3c624ac36ed76bb317474893b92b5dac4c5884eb9f1fec3"
    sha256 cellar: :any, arm64_sequoia:     "6453db5c6dba77200b4a1a653912bc63d251bdf2c8649c69ce19c336cfb3494a"
    sha256 cellar: :any, arm64_linux:       "6257cffda7c33bead9b19a1fc8999303191b2684e79c965439f945633e5a87eb"
    sha256 cellar: :any, x86_64_linux:      "dce42875d737b81860b044edfb837626906d4d118cc5f66d03053dbcbcf72908"
  end

  depends_on "pkgconf" => :build
  depends_on "brotli"
  depends_on "libpng"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # This file will be installed to bindir, so we want to avoid embedding the
    # absolute path to the pkg-config shim.
    inreplace "builds/unix/freetype-config.in", "%PKG_CONFIG%", "pkg-config"

    system "./configure", "--prefix=#{prefix}",
                          "--enable-freetype-config",
                          "--with-brotli",
                          "--without-harfbuzz"
    system "make"
    system "make", "install"

    inreplace [bin/"freetype-config", lib/"pkgconfig/freetype2.pc"],
      prefix, opt_prefix
  end

  test do
    system bin/"freetype-config", "--cflags", "--libs", "--ftversion",
                                  "--exec-prefix", "--prefix"
  end
end