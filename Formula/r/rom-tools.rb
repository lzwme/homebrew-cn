class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://ghproxy.com/https://github.com/mamedev/mame/archive/refs/tags/mame0259.tar.gz"
  version "0.259"
  sha256 "46baf431079a3373ffe8d984b3ba5d62ad5b1d5e356d1f60cf60f6ad03d4cec6"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/mamedev/mame.git", branch: "master"

  livecheck do
    formula "mame"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "80f441600eb1b738ce84b08001a011fbafde02e6b51d4a4fbf77619fd181203c"
    sha256 cellar: :any,                 arm64_ventura:  "179c55da9174201dce66aa7a8b8886a7577ff3c2fb4e0a5cd4145a0b1e5c7157"
    sha256 cellar: :any,                 arm64_monterey: "1353ef375f678f19e53fec5b8d9a37be4222f593e8c3e8f7675a0f97777e59d0"
    sha256 cellar: :any,                 sonoma:         "13045585028573e7d16ddb1a233acc61c912b20346dcfc1e01d2a505cfbf71ba"
    sha256 cellar: :any,                 ventura:        "2130faa7280598c540e121423091f3acc1d9ba62d47f417984d61587343b7234"
    sha256 cellar: :any,                 monterey:       "011d75a845044a9d80b91d6419192e46a1a894d21e874c32e1156a611af35b3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0c2dc423f46a841a1c8057516529debae7bf1f7547926e257d7fd1138221ad6"
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