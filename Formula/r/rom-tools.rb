class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "https:www.mamedev.org"
  url "https:github.commamedevmamearchiverefstagsmame0276.tar.gz"
  version "0.276"
  sha256 "965dfc33d720b4c3c6e425d5959540bd0bac88e96b878a8560678c2f5b43c44f"
  license "GPL-2.0-or-later"
  head "https:github.commamedevmame.git", branch: "master"

  livecheck do
    formula "mame"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fc8624c6720e839c490dd8551dee1807874f1e8a30b87da4f1bfad9881bb3c8c"
    sha256 cellar: :any,                 arm64_sonoma:  "338a2aed1bbe68afbd5996cce2e592660cfe1755e775f05612d0856f91aa4565"
    sha256 cellar: :any,                 arm64_ventura: "109730b8936e0c57479abc9f191b2dbd16a2e530fded07224b24c65dce2d26a8"
    sha256 cellar: :any,                 sonoma:        "c9dec801971e42afd8b7c8f93315145fd7856ec3e67123f35218c210c887e579"
    sha256 cellar: :any,                 ventura:       "c2500f50fe8a8790513dd361bdd686085f48b8554f6f1ae776b3c344d4fb99d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3619deb59afe9d5b9802d9e419865ebadf4af0fd8ce6dba6ef21ca4fe68a047e"
  end

  depends_on "asio" => :build
  depends_on "pkgconf" => :build
  depends_on "flac"
  # Need C++ compiler and standard library support C++17.
  depends_on macos: :high_sierra
  depends_on "sdl2"
  depends_on "utf8proc"
  depends_on "zstd"

  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    depends_on "portaudio" => :build
    depends_on "portmidi" => :build
    depends_on "pulseaudio" => :build
    depends_on "qt" => :build
    depends_on "sdl2_ttf" => :build
  end

  def install
    ENV["QT_HOME"] = Formula["qt"].opt_prefix if OS.linux?

    # Cut sdl2-config's invalid option.
    inreplace "scriptssrcosdsdl.lua", "--static", ""

    args = %W[
      PYTHON_EXECUTABLE=#{which("python3")}
      TOOLS=1
      EMULATOR=0
      USE_LIBSDL=1
      USE_SYSTEM_LIB_EXPAT=1
      USE_SYSTEM_LIB_ZLIB=1
      USE_SYSTEM_LIB_ASIO=1
      USE_SYSTEM_LIB_FLAC=1
      USE_SYSTEM_LIB_UTF8PROC=1
      USE_SYSTEM_LIB_ZSTD=1
      VERBOSE=1
    ]
    if OS.linux?
      args << "USE_SYSTEM_LIB_PORTAUDIO=1"
      args << "USE_SYSTEM_LIB_PORTMIDI=1"
    end
    system "make", *args

    bin.install %w[
      castool chdman floptool imgtool jedutil ldresample ldverify
      nltool nlwav pngcmp regrep romcmp srcclean testkeys unidasm
    ]
    bin.install "split" => "rom-split"
    bin.install "aueffectutil" if OS.mac?
    man1.install Dir["docsman*.1"]
  end

  # Needs more comprehensive tests
  test do
    # system "#{bin}aueffectutil" # segmentation fault
    system bin"castool"
    assert_match "chdman info", shell_output("#{bin}chdman help info", 1)
    system bin"floptool"
    system bin"imgtool", "listformats"
    system bin"jedutil", "-viewlist"
    assert_match "linear equation", shell_output("#{bin}ldresample 2>&1", 1)
    assert_match "avifile.avi", shell_output("#{bin}ldverify 2>&1", 1)
    system bin"nltool", "--help"
    system bin"nlwav", "--help"
    assert_match "image1", shell_output("#{bin}pngcmp 2>&1", 10)
    assert_match "summary", shell_output("#{bin}regrep 2>&1", 1)
    system bin"romcmp"
    system bin"rom-split"
    system bin"srcclean"
    assert_match "architecture", shell_output("#{bin}unidasm", 1)
  end
end