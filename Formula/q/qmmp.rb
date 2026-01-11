class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "https://qmmp.ylsoftware.com/"
  url "https://qmmp.ylsoftware.com/files/qmmp/2.3/qmmp-2.3.1.tar.bz2"
  sha256 "a61d1c1faa9c411c75292a5710999182b918831b8f0f200c87149e3ff353bea9"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://qmmp.ylsoftware.com/downloads.php"
    regex(/href=.*?qmmp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "f6f475ce1d985bbc1f5629a8fc3eca7fdef4b455236bbe5014826a9808fb8877"
    sha256 cellar: :any,                 arm64_sequoia: "14df780f8490ea8f942f2735f42d8055d842f1a4b9bdd2f397084d240dd8995a"
    sha256 cellar: :any,                 arm64_sonoma:  "5afff4d2c09436aafc49521a5a548f4c53e82d9c8194ffddec947bcab58c0dd2"
    sha256 cellar: :any,                 sonoma:        "22671d345648a48ac2e78f8aeeb9ba04671fd81de20665597afe41b5702f38aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4d1f4306bd1e5f83896efd45d48b0d53a7c48bbe0a45c3daff45879ae8ae403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fe25b0aa178b76e52520e2d586dc3cecd274def275c79093187aa063a970477"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "qttools" => :build

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
  end

  resource "qmmp-plugin-pack" do
    url "https://qmmp.ylsoftware.com/files/qmmp-plugin-pack/2.3/qmmp-plugin-pack-2.3.0.tar.bz2"
    sha256 "a23c202f90faaf6aebb97a9c02ee21fb3c8164b07755514349ccb3e1acb81ab5"

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