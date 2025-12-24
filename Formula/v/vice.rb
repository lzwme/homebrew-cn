class Vice < Formula
  desc "Versatile Commodore Emulator"
  homepage "https://sourceforge.net/projects/vice-emu/"
  url "https://downloads.sourceforge.net/project/vice-emu/releases/vice-3.9.tar.gz"
  sha256 "40202b63455e26b87ecc63eb5a52322c6fa3f57cab12acf0c227cf9f4daec370"
  license "GPL-2.0-or-later"
  revision 1
  head "https://svn.code.sf.net/p/vice-emu/code/trunk/vice"

  livecheck do
    url :stable
    regex(%r{url=.*?/vice[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "48ff65acfffb8aa3e3be49a0af15e562b31b5399d4e6af0b753b5703e7affd32"
    sha256 arm64_sequoia: "cc2a998256bbc7166b7e2c91be9ce02966d5d243f9218bd0843185fd5f25a8b8"
    sha256 arm64_sonoma:  "154373a70308d1f5777342f29cf0284d99d58199e5f16f31ada76b545e76fa42"
    sha256 sonoma:        "6fa288ad937306036e0015227243efa3c4c94fb193a7e3bd4ee3cd4f3bac4174"
    sha256 arm64_linux:   "d2702dfba91882288ca8222550110b83c43890d874d65e0dca0ccd942e085ce5"
    sha256 x86_64_linux:  "a0741c399bfdb33f3a426f4e6a3045c5562cb6f503f558248fb515b11b1a2f98"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "dos2unix" => :build
  depends_on "pkgconf" => :build
  depends_on "texinfo" => :build
  depends_on "xa" => :build
  depends_on "yasm" => :build

  depends_on "adwaita-icon-theme"
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "flac"
  depends_on "gdk-pixbuf"
  depends_on "giflib"
  depends_on "glew"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "lame"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libvorbis"
  depends_on "pango"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "fontconfig"
    depends_on "libx11"
    depends_on "mesa"
    depends_on "pulseaudio"
  end

  def install
    system "./autogen.sh"

    system "./configure", "--disable-arch",
                          "--disable-pdf-docs",
                          "--enable-gtk3ui",
                          "--enable-midi",
                          "--enable-lame",
                          "--enable-ethernet",
                          "--enable-cpuhistory",
                          "--with-flac",
                          "--with-vorbis",
                          "--with-gif",
                          "--with-png",
                          "--without-evdev", # TODO: needs libevdev
                          *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/x64sc -console -limitcycles 1000000", 1)
    assert_match "Initializing chip model", output
  end
end