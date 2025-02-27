class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "https:www.mamedev.org"
  url "https:github.commamedevmamearchiverefstagsmame0275.tar.gz"
  version "0.275"
  sha256 "cf12c3c40a94f7bc67deefa69923a0769f99b66dc15bd7e2505b3130df6130bb"
  license "GPL-2.0-or-later"
  head "https:github.commamedevmame.git", branch: "master"

  livecheck do
    formula "mame"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "271ffcfcec49cd9b886cb448e81a02544e8bb002e03274ce858b9eccc6d72382"
    sha256 cellar: :any,                 arm64_sonoma:  "378f1856f64e56905fedb4322126bf2e7e791bd3b9b4ffabaa9c41f6b4918edf"
    sha256 cellar: :any,                 arm64_ventura: "332278e88a33328716fc9127b884054defd6c49126429ade1270db642f8d9b0d"
    sha256 cellar: :any,                 sonoma:        "37e3f86fe65f3f8d6533c44b316e9a895ba5ab69903cf98aa93b7d6f6c64b7c4"
    sha256 cellar: :any,                 ventura:       "f0303cbdf3d9d04ad5f2b000cc684f967fa3b4dbbca77b9bd4c4286cb7e65e02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64b4266a478b52a0b1903ac566ce3617411d437ed86d97553222711883844135"
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