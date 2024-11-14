class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "https:qmmp.ylsoftware.com"
  url "https:qmmp.ylsoftware.comfilesqmmp2.2qmmp-2.2.2.tar.bz2"
  sha256 "53055984b220ec1f825b885db3ebdb54a7a71ac67935438ee4ff9c082f600c4f"
  license "GPL-2.0-or-later"

  livecheck do
    url "https:qmmp.ylsoftware.comdownloads.php"
    regex(href=.*?qmmp[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "515b38786fd3299f49dda650f810b4278faeec35ad6003a60ae072c25c93a4d6"
    sha256 cellar: :any,                 arm64_ventura: "cac00b68eaabb52ee9f93d54da5b68fe52de4cb7f39e798f3716f0c99fadb3cd"
    sha256 cellar: :any,                 sonoma:        "49a2054e2552565d1942d4fcc916b3402f7ae52b178844694869f7cbcb9dc72b"
    sha256 cellar: :any,                 ventura:       "83c5f7524a1119d497b34303ffa0df3100d7bb179945e3567574ce0e5befe91c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dde277e48b32110088fa920e36c15d64d5ff5bb1d26e7835dde8bbff01c0f029"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  # TODO: on linux: pipewire
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "game-music-emu"
  depends_on "jack"
  depends_on "libarchive"
  depends_on "libbs2b"
  depends_on "libcddb"
  depends_on "libcdio"
  depends_on "libmms"
  depends_on "libmodplug"
  depends_on "libogg"
  depends_on "libsamplerate"
  depends_on "libshout"
  depends_on "libsndfile"
  depends_on "libsoxr"
  depends_on "libvorbis"
  depends_on "libxcb"
  depends_on "libxmp"
  depends_on "mad"
  depends_on "mpg123"
  depends_on "mplayer"
  depends_on "opus"
  depends_on "opusfile"
  depends_on "projectm"
  depends_on "pulseaudio"
  depends_on "qt"
  depends_on "taglib"
  depends_on "wavpack"
  depends_on "wildmidi"

  uses_from_macos "curl"

  on_macos do
    depends_on "gettext"
    depends_on "glib"
    # musepack is not bottled on Linux
    # https:github.comHomebrewhomebrew-corepull92041
    depends_on "musepack"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "libx11"
    depends_on "mesa"
  end

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  resource "qmmp-plugin-pack" do
    url "https:qmmp.ylsoftware.comfilesqmmp-plugin-pack2.2qmmp-plugin-pack-2.2.1.tar.bz2"
    sha256 "bfb19dfc657a3b2d882bb1cf4069551488352ae920d8efac391d218c00770682"
  end

  def install
    cmake_args = std_cmake_args + %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_STAGING_PREFIX=#{prefix}
      -DUSE_SKINNED=ON
      -DUSE_ENCA=ON
      -DUSE_QMMP_DIALOG=ON
    ]
    if OS.mac?
      cmake_args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup"
      cmake_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup"
      cmake_args << "-DCMAKE_MODULE_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup"
    end

    # Fix to recognize x11
    # Issue ref: https:sourceforge.netpqmmp-devtickets1177
    inreplace "srcpluginsUiskinnedCMakeLists.txt", "PkgConfig::X11", "${X11_LDFLAGS}"

    system "cmake", "-S", ".", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

    ENV.append_path "PKG_CONFIG_PATH", lib"pkgconfig"
    resource("qmmp-plugin-pack").stage do
      system "cmake", ".", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "cmake", "--build", "."
      system "cmake", "--install", "."
    end
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error "qt.qpa.xcb: could not connect to display"
    ENV["QT_QPA_PLATFORM"] = "minimal" unless OS.mac?
    system bin"qmmp", "--version"
  end
end