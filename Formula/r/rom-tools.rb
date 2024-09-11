class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "https:mamedev.org"
  url "https:github.commamedevmamearchiverefstagsmame0269.tar.gz"
  version "0.269"
  sha256 "05df2e82ff1d157282a5a667a67aa6eb331c55a64138afad0e8ac223553088ca"
  license "GPL-2.0-or-later"
  head "https:github.commamedevmame.git", branch: "master"

  livecheck do
    formula "mame"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "549a183c1161853fe7400f6830d12a28c58c17a3f05fb3b7ab9f5182dd86768f"
    sha256 cellar: :any,                 arm64_sonoma:   "579978ebf4925a56ed82e6410ca9f2f92f7328b6d0200616cb60c8b769894804"
    sha256 cellar: :any,                 arm64_ventura:  "1ddb6aa64e3bf5798ae9ff8788117e6e2b7f67722865cd2c498b774c05ee1e7c"
    sha256 cellar: :any,                 arm64_monterey: "8c684a5dbf6ca3189667c9b8bf4d3ce234be9585b7372cc0f14534c4127346cf"
    sha256 cellar: :any,                 sonoma:         "8d2b3fa7e12063f2a13afbd2597473b86a9895cec4c886115c11da123817add2"
    sha256 cellar: :any,                 ventura:        "6d5e42831c8efca055c90955c5b004d926f532a44ceeca66a470164f14e3bf06"
    sha256 cellar: :any,                 monterey:       "e0eeae6cf1bd69783c451ea3462aa2e03ce8957c65298400971a4b846f87c371"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07169ce23eb9e8939f83771d578789dfbd175a46fb27829484198384ba0cf9f4"
  end

  depends_on "asio" => :build
  depends_on "pkg-config" => :build
  depends_on "flac"
  # Need C++ compiler and standard library support C++17.
  depends_on macos: :high_sierra
  depends_on "sdl2"
  depends_on "utf8proc"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    depends_on "portaudio" => :build
    depends_on "portmidi" => :build
    depends_on "pulseaudio" => :build
    depends_on "qt@5" => :build
    depends_on "sdl2_ttf" => :build
  end

  fails_with gcc: "5" # for C++17
  fails_with gcc: "6"

  def install
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