class Vice < Formula
  desc "Versatile Commodore Emulator"
  homepage "https://sourceforge.net/projects/vice-emu/"
  url "https://downloads.sourceforge.net/project/vice-emu/releases/vice-3.7.1.tar.gz"
  sha256 "7e3811e6024db0698bfbc321bb324572446b8853d01b4073f09865957b0cab98"
  license "GPL-2.0-or-later"
  revision 1
  head "https://svn.code.sf.net/p/vice-emu/code/trunk/vice"

  livecheck do
    url :stable
    regex(%r{url=.*?/vice[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "39c8dc172e0dfc304fb76849778079cee5f4389857388d1a5585cb9d9622d110"
    sha256 arm64_ventura:  "d2ccbb52caaaeaf1d09809fe69bfa78486b5b197fd5aaf3f95b43822880e9436"
    sha256 arm64_monterey: "7a6ecdee0102c7804a5a936a4a6576039dfb966499c44a3e73be7d142b79a515"
    sha256 sonoma:         "4180e55847f87f0b2e7d4fd9b5ff6d97b2a7e117f817e3edbf7b2f8f7d70f376"
    sha256 ventura:        "f1fa4037f0688150acba2a8e6f546817d530dfab0f24fb16744f2b8181ed22c5"
    sha256 monterey:       "0cbd22236550ec4d35246a355bd1c88d06d43abaa14c39c554172d08ea80c55a"
    sha256 x86_64_linux:   "745e3282856808e1fc623dafd4a324e797661d7af6940081994e56cd22afd3d4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "dos2unix" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "xa" => :build
  depends_on "yasm" => :build

  depends_on "adwaita-icon-theme"
  depends_on "flac"
  depends_on "giflib"
  depends_on "glew"
  depends_on "gtk+3"
  depends_on "lame"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libvorbis"
  depends_on "readline" # Possible opportunistic linkage. TODO: Check if this can be removed.

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "pulseaudio"
  end

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args,
                          "--disable-arch",
                          "--disable-pdf-docs",
                          "--enable-gtk3ui",
                          "--enable-midi",
                          "--enable-lame",
                          "--enable-ethernet",
                          "--enable-cpuhistory",
                          "--with-flac",
                          "--with-vorbis",
                          "--with-gif",
                          "--with-png"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/x64sc -console -limitcycles 1000000 -logfile -", 1)
    assert_match "Initializing chip model", output
  end
end