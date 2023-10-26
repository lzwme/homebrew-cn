class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://ghproxy.com/https://github.com/mamedev/mame/archive/refs/tags/mame0260.tar.gz"
  version "0.260"
  sha256 "104ca8daab3ce7bb9637e19f1dc60a08ac6856db730ab544275567addb9541cd"
  license "GPL-2.0-or-later"
  head "https://github.com/mamedev/mame.git", branch: "master"

  livecheck do
    formula "mame"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4f8f8e62379a118efc090e3edee155bc966888cc61b7c0cd764f94477dfbf944"
    sha256 cellar: :any,                 arm64_ventura:  "e50849e6b8f3503d82dc53134fdcdc0e37bfaadc024299efac0f423407ded709"
    sha256 cellar: :any,                 arm64_monterey: "d675a67f88318fbcf3dba8c5fc033c5fc143b8710e071c9169e1fab39f30715b"
    sha256 cellar: :any,                 sonoma:         "8238b12c928ad703df95fffb179a3a9ab6aeb869b873fa3c07a92236f93dc217"
    sha256 cellar: :any,                 ventura:        "20c9cde80d085de67c92f123d0c35823b4cc85c45e5c6e4b6904181827ddc3a1"
    sha256 cellar: :any,                 monterey:       "7101e2d979377df71ecc69245af86e257cb29f0e27c46b36fe3838270bbcc44a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c716e673c5017afd1238c81600c5c3ff0c2f63a14778e86d2dccdfcde01dd1c"
  end

  depends_on "asio" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "flac"
  # Need C++ compiler and standard library support C++17.
  depends_on macos: :high_sierra
  depends_on "sdl2"
  depends_on "utf8proc"

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
    inreplace "scripts/src/osd/sdl.lua", "--static", ""

    args = %W[
      PYTHON_EXECUTABLE=#{which("python3.11")}
      TOOLS=1
      USE_LIBSDL=1
      USE_SYSTEM_LIB_EXPAT=1
      USE_SYSTEM_LIB_ZLIB=1
      USE_SYSTEM_LIB_ASIO=1
      USE_SYSTEM_LIB_FLAC=1
      USE_SYSTEM_LIB_UTF8PROC=1
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
    man1.install Dir["docs/man/*.1"]
  end

  # Needs more comprehensive tests
  test do
    # system "#{bin}/aueffectutil" # segmentation fault
    system "#{bin}/castool"
    assert_match "chdman info", shell_output("#{bin}/chdman help info", 1)
    system "#{bin}/floptool"
    system "#{bin}/imgtool", "listformats"
    system "#{bin}/jedutil", "-viewlist"
    assert_match "linear equation", shell_output("#{bin}/ldresample 2>&1", 1)
    assert_match "avifile.avi", shell_output("#{bin}/ldverify 2>&1", 1)
    system "#{bin}/nltool", "--help"
    system "#{bin}/nlwav", "--help"
    assert_match "image1", shell_output("#{bin}/pngcmp 2>&1", 10)
    assert_match "summary", shell_output("#{bin}/regrep 2>&1", 1)
    system "#{bin}/romcmp"
    system "#{bin}/rom-split"
    system "#{bin}/srcclean"
    assert_match "architecture", shell_output("#{bin}/unidasm", 1)
  end
end