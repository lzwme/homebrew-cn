class Gpa < Formula
  desc "Graphical user interface for the GnuPG"
  homepage "https://www.gnupg.org/related_software/gpa/"
  license "GPL-3.0-or-later"
  revision 1

  stable do
    url "https://gnupg.org/ftp/gcrypt/gpa/gpa-0.11.0.tar.bz2"
    mirror "https://deb.debian.org/debian/pool/main/g/gpa/gpa_0.11.0.orig.tar.bz2"
    sha256 "26a8fa5bf70541cb741f0c71b7cfe291b1ea56eab68eeb07aa962cef5cdf33cc"

    # Fix for `gpgme` >= 2.0.0 compatibility
    patch do
      url "https://git.gnupg.org/cgi-bin/gitweb.cgi?p=gpa.git;a=patch;h=b6ba8bcc6db7765667cd6c49b7edc9a2073bc74f"
      sha256 "3aab76d3d79cad0c756f9c73cc237b8632ae9e7f68d5f7715c3ca58e2c633bc5"
    end
  end

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpa/"
    regex(/href=.*?gpa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "0f1a21e947f1268c78fb45f469d1134adef70766f2be5dbd0092ba504b31dc7e"
    sha256 arm64_sequoia: "43fb96ff4d8c951a804b9a1e891110b2eb138925caef26d7942ce7a1cc2fd1b3"
    sha256 arm64_sonoma:  "a3570404bc9e51826612905388c9d8f66b7ba2d25e7baf24758d63302e82ef08"
    sha256 sonoma:        "d44cd68a57d3ec28953b8f4e3ec838846f5dbe5b115465ab2bcac8c44460810d"
    sha256 arm64_linux:   "9e3f3b085044a1d8a9d2c5a730127ab5c8f0fe22ac46a524aa69fa4fe66cfdd5"
    sha256 x86_64_linux:  "35990987cdef9ec1513d793652b99a2bb38fe5c270da32bfca3b6cd68faa5626"
  end

  head do
    url "https://dev.gnupg.org/source/gpa.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "desktop-file-utils" => :build
  depends_on "pkgconf" => :build

  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gpgme"
  depends_on "gtk+3"
  depends_on "libassuan"
  depends_on "libgpg-error"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "cairo"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    inreplace "configure", "NEED_LIBASSUAN_API=2", "NEED_LIBASSUAN_API=3"

    ENV.append_to_cflags "-Wno-implicit-function-declaration"

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"gpa", "--version"
  end
end