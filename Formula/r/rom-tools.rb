class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "https:www.mamedev.org"
  url "https:github.commamedevmamearchiverefstagsmame0274.tar.gz"
  version "0.274"
  sha256 "f8112eb0b175935cf6db93f708186dcaeec5a89400ecf3d5782fd2c0b94907c8"
  license "GPL-2.0-or-later"
  revision 1
  head "https:github.commamedevmame.git", branch: "master"

  livecheck do
    formula "mame"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5188627d52e07e31f1daeecd80d0ee1059a48e499a05c00fbeb3e646bd8cb53a"
    sha256 cellar: :any,                 arm64_sonoma:  "7223ac1362b9895c25a1a63e6d3f74bc160e5eee3d63775c70eda32b0f4bc6b0"
    sha256 cellar: :any,                 arm64_ventura: "f8f9ef9b687489c7f0509d0bb97a5ba41f66bda542d8b9dfb14563de37b2cf7d"
    sha256 cellar: :any,                 sonoma:        "33461a11ac7b133b80c1a13fbaa03560ee10f7ff2164dfc674c1f52305c9b87f"
    sha256 cellar: :any,                 ventura:       "1bb0d1445bfb480e585dd0410c1b20f8a44b3ce7d9504a74fa7d6eacb990905d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa6ebd8aeb9700f81a96342c128f4bd496e057620d7d58cfbf24b0b5c53c7868"
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