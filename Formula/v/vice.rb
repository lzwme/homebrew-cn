class Vice < Formula
  desc "Versatile Commodore Emulator"
  homepage "https://sourceforge.net/projects/vice-emu/"
  url "https://downloads.sourceforge.net/project/vice-emu/releases/vice-3.8.tar.gz"
  sha256 "1d7dc4d0f2bbcc2a871bb954ff4a5df63048dea9c16f5f1e9bc8260fa41a1004"
  license "GPL-2.0-or-later"
  revision 1
  head "https://svn.code.sf.net/p/vice-emu/code/trunk/vice"

  livecheck do
    url :stable
    regex(%r{url=.*?/vice[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "5b90dae6e48945d2a2e9bcb171d3e738f84eaa4509b271464f077306cac2170c"
    sha256 arm64_sonoma:  "df507a393d84b5b9a26ba24dd7b25cf5970d9e863c3434192b8acf17b0e6c87d"
    sha256 arm64_ventura: "d1acd6e4620e02665f26fadb7a17a3d61de4d17a5f0b0a32bfbc2f85ac4199d2"
    sha256 sonoma:        "d2ce9b6154fb38eeba565303cd320235184c8bb45d17479f4a8d067efe284d8e"
    sha256 ventura:       "4748297e9155eae2c4afd61c48e6385b0dbc5ec342850f34b4624d13421818d1"
    sha256 x86_64_linux:  "8cd08ba6580c9d429534acdc4bb5a8edad01f1a1c30000c78258b9366bd2a4b3"
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
                          *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/x64sc -console -limitcycles 1000000 -logfile -", 1)
    assert_match "Initializing chip model", output
  end
end