class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "https:qmmp.ylsoftware.com"
  url "https:qmmp.ylsoftware.comfilesqmmp2.2qmmp-2.2.3.tar.bz2"
  sha256 "993e57d8e11b083bb6f246738505edf35d498ffe82a1936f3129b8bb09eab244"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https:qmmp.ylsoftware.comdownloads.php"
    regex(href=.*?qmmp[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "5a026724dfaa94732e7cc749baa013bc25782b03e6155f40025fc6692fe4b1b3"
    sha256 cellar: :any,                 arm64_ventura: "0097a2462c6cd4af2f8e017117d57bf04cdb8eae14e2ec2add0b09d764d940c1"
    sha256 cellar: :any,                 sonoma:        "2683f5bb4937701adaa655158da8f78eeea817622c7f7fd020ce9110c2fbb851"
    sha256 cellar: :any,                 ventura:       "50553475fd30aea759262b890cf9f7cf9dbd89a43cfae266607b482c11add98b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b154d59693a72394df6eb920a2c193b4b55f2f892a18f4989ffcf3465f7228a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

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

  resource "qmmp-plugin-pack" do
    url "https:qmmp.ylsoftware.comfilesqmmp-plugin-pack2.2qmmp-plugin-pack-2.2.1.tar.bz2"
    sha256 "bfb19dfc657a3b2d882bb1cf4069551488352ae920d8efac391d218c00770682"
  end

  # add taglib 2.x support
  patch do
    url "https:sources.debian.orgdatamainqqmmp2.2.3-1debianpatches0002-Fix-taglib-2.x-compatibility.patch"
    sha256 "837bea7d6af9dc0be072b450f74ce9382ae1c7963d2e4a78c9eb2208b283ea62"
  end

  def install
    cmake_args = %W[
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

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    ENV.append_path "PKG_CONFIG_PATH", lib"pkgconfig"
    resource("qmmp-plugin-pack").stage do
      system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error "qt.qpa.xcb: could not connect to display"
    ENV["QT_QPA_PLATFORM"] = "minimal" unless OS.mac?
    system bin"qmmp", "--version"
  end
end