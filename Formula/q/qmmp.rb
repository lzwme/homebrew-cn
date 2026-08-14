class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "https://qmmp.ylsoftware.com/"
  url "https://qmmp.ylsoftware.com/files/qmmp/2.4/qmmp-2.4.0.tar.bz2"
  sha256 "1902fa102cdf3da5cab986a73cc50bb835e653f1b655f6eac8bbeeec526b362f"
  license "GPL-2.0-or-later"
  livecheck do
    url "https://qmmp.ylsoftware.com/downloads.php"
    regex(/href=.*?qmmp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b6beecc4f09b19bb85fd95c62b86cbab50a20eaba5a60393796f3fbaa337b905"
    sha256 cellar: :any, arm64_sequoia: "03a5c5ac240d3e4b3ab0d9a586de4a2d7b3eeda1492d5c67de515c9c1a6c83bc"
    sha256 cellar: :any, arm64_sonoma:  "c8c1de24ae30b92a5f8552cb76358afb487e5f4d0b29a21e22dcd972aa1b359b"
    sha256 cellar: :any, sonoma:        "236543c81f5d2a1dafbc53b2ff1bc070de99ec922fb735ee47a2936b3f76aa95"
    sha256 cellar: :any, arm64_linux:   "7554d99ec2eb1c631ad67791baca2335a5ab48359ba882f441d35cac940215c3"
    sha256 cellar: :any, x86_64_linux:  "701f1248888117146f581041a4418937fc75bdbb98cb91abd6aac1acfb96a8ae"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "qttools" => :build

  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "game-music-emu"
  depends_on "jack"
  depends_on "libarchive"
  depends_on "libbs2b"
  depends_on "libcddb"
  depends_on "libcdio"
  depends_on "libcdio-paranoia"
  depends_on "libmms"
  depends_on "libmodplug"
  depends_on "libogg"
  depends_on "libsamplerate"
  depends_on "libshout"
  depends_on "libsndfile"
  depends_on "libsoxr"
  depends_on "libvorbis"
  depends_on "libxmp"
  depends_on "mad"
  depends_on "mpg123"
  depends_on "mplayer"
  depends_on "musepack"
  depends_on "opus"
  depends_on "opusfile"
  depends_on "projectm"
  depends_on "pulseaudio"
  depends_on "qtbase"
  depends_on "qtmultimedia"
  depends_on "taglib"
  depends_on "wavpack"
  depends_on "wildmidi"

  uses_from_macos "curl"

  on_macos do
    depends_on "gettext"
    depends_on "glib"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "mesa"
    depends_on "pipewire"
  end

  resource "qmmp-plugin-pack" do
    url "https://qmmp.ylsoftware.com/files/qmmp-plugin-pack/2.4/qmmp-plugin-pack-2.4.0.tar.bz2"
    sha256 "db677a522b6755bb6281ea18ed5ecf994d87bce61ca0e82a3bb47c8f7c119dd7"

    livecheck do
      url "https://qmmp.ylsoftware.com/plugins.php"
      regex(/href=.*?qmmp-plugin-pack[._-]v?(\d+(?:\.\d+)+)\.t/i)
    end
  end

  def install
    rpaths = [rpath, "#{loader_path}/../.."]
    cmake_args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}
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

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    ENV.append_path "PKG_CONFIG_PATH", lib/"pkgconfig"
    resource("qmmp-plugin-pack").stage do
      system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}", *std_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error "qt.qpa.xcb: could not connect to display"
    ENV["QT_QPA_PLATFORM"] = "minimal" unless OS.mac?
    system bin/"qmmp", "--version"
  end
end