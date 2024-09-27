class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "https:mamedev.org"
  url "https:github.commamedevmamearchiverefstagsmame0270.tar.gz"
  version "0.270"
  sha256 "0364b670478883902c2bc618908192b0590235b47fbe073fcac2d13b82541437"
  license "GPL-2.0-or-later"
  head "https:github.commamedevmame.git", branch: "master"

  livecheck do
    formula "mame"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d3c131988a1a999ace5c61b1ae456f8bd4fd42261f08a521ab436203ce5e7946"
    sha256 cellar: :any,                 arm64_sonoma:  "356b3c69bc6b1d2b722dc12041c1f8a0ce472e5d7b30141f3b313129af9a344c"
    sha256 cellar: :any,                 arm64_ventura: "cebecc43762c872e7eeb26bbb24f2f631b32fa2589fac1c6879aea5b0752fbd7"
    sha256 cellar: :any,                 sonoma:        "509ee2be0acd7255782f4a5c1c4477cdf822133a242d6696c1230cee7639bf75"
    sha256 cellar: :any,                 ventura:       "748eedafaaa06acfd708992ad9132233efee5fa0333bb29f9f56186c256191f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa472ee8fab69add222aaa02d6d9b4aa923d5ca9536e4343a6fba2f2bdf38d17"
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