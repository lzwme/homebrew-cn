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
    sha256 arm64_sonoma:   "f385fcf101519c31d6caf155461008950f4258f10bd9c07b1caa1507801f8068"
    sha256 arm64_ventura:  "45c2e5dc82f00a9af1f842952d973006a9271d1f95aa453daade60590c350868"
    sha256 arm64_monterey: "56d9320d1308a310dfb61dd1f126c5c6aa4fcafb7624be35c089aac350efd715"
    sha256 sonoma:         "9413ef0f9df6e275973281fcba2af9acb8a8c63b8129bd460b94d03cdd963516"
    sha256 ventura:        "999c76296b09f407237461816f845f7277ec64e3ed33ffc65fb6879967d1d8b7"
    sha256 monterey:       "fd062a03b9dca57b8a2da3e4a2183f3724fb9103297a5b9f2e377c86798ea9f4"
    sha256 x86_64_linux:   "8e63953db7b910bc8ad0e8ebcd4690d7e978be37bf0d6976e2aa9b39589bc7e4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "dos2unix" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "xa" => :build
  depends_on "yasm" => :build

  depends_on "adwaita-icon-theme"
  depends_on "ffmpeg@4"
  depends_on "flac"
  depends_on "giflib"
  depends_on "glew"
  depends_on "gtk+3"
  depends_on "jpeg-turbo"
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
  end

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args,
                          "--disable-arch",
                          "--disable-pdf-docs",
                          "--enable-native-gtk3ui",
                          "--enable-midi",
                          "--enable-lame",
                          "--enable-external-ffmpeg",
                          "--enable-ethernet",
                          "--enable-cpuhistory",
                          "--with-flac",
                          "--with-vorbis",
                          "--with-gif",
                          "--with-jpeg",
                          "--with-png"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/x64sc -console -limitcycles 1000000 -logfile -", 1)
    assert_match "Initializing chip model", output
  end
end