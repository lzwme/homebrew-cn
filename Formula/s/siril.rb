class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  license "GPL-3.0-or-later"
  revision 3
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  stable do
    url "https://free-astro.org/download/siril-1.2.0.tar.bz2"
    sha256 "5941a4b5778929347482570dab05c9d780f3ab36e56f05b6301c39d911065e6f"

    # TODO: Remove this patch on the next version after 1.2.0.
    patch do
      url "https://gitweb.gentoo.org/repo/gentoo.git/plain/sci-astronomy/siril/files/siril-1.2-exiv2-0.28.patch?id=002882203ad6a2b08ce035a18b95844a9f4b85d0"
      sha256 "023a1a084f3005ed90649e71c70d59335d2efcd06875433f2cc2841f9d357eba"
    end
  end

  bottle do
    sha256 arm64_sonoma:   "eb9487135cc6b10a91c44ab8ca3efb9bce19d80b069897bf22b3ca7edbc66b39"
    sha256 arm64_ventura:  "2e92f421d3cf23ae45a455a2f6a6c6b63a53fba710d9038f52891e570db5e8b0"
    sha256 arm64_monterey: "306fc615674ad2c494b806590250a1187b34fb8222be8ddc36f18bfb682c88d5"
    sha256 sonoma:         "94e87f2e43a26dab579f6a53dfe3aeb6b86d6c62754c2f0af48b5668a20de449"
    sha256 ventura:        "0dcf222209a7173b1d31e44b32056fe96b225b2143d171925a457e76c293483c"
    sha256 monterey:       "73ffc24d76f9cbd7da62b054ea4a8ae5829c7a68d873c6fedad70e902a8441bc"
    sha256 x86_64_linux:   "3c44a843b64f49cd9e4ffa398da0b9de14a57a986186c89de84213ae4689d4a8"
  end

  depends_on "cmake" => :build
  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "cfitsio"
  depends_on "exiv2"
  depends_on "ffms2"
  depends_on "fftw"
  depends_on "gnuplot"
  depends_on "gsl"
  depends_on "gtk+3"
  depends_on "jpeg-turbo"
  depends_on "json-glib"
  depends_on "libconfig"
  depends_on "libheif"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "netpbm"
  depends_on "opencv"
  depends_on "openjpeg"
  depends_on "wcslib"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "gtk-mac-integration"
    depends_on "libomp"
  end

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    args = %w[
      --force-fallback-for=kplot
    ]

    system "meson", "setup", "_build", *args, *std_meson_args
    system "meson", "compile", "-C", "_build", "--verbose"
    system "meson", "install", "-C", "_build"
  end

  test do
    system bin/"siril", "-v"
  end
end