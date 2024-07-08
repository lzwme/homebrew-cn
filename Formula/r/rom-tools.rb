class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "https:mamedev.org"
  url "https:github.commamedevmamearchiverefstagsmame0267.tar.gz"
  version "0.267"
  sha256 "c6dacd02080ab20512a7d15fc6a1715879912d7482df6b4d5f36849e1ae5813f"
  license "GPL-2.0-or-later"
  head "https:github.commamedevmame.git", branch: "master"

  livecheck do
    formula "mame"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "549d0efe3c272d144a7b2c2c31e9cb61e09322641a38eae80368b96ff769cf06"
    sha256 cellar: :any,                 arm64_ventura:  "801743605540ab3026da7a5c0bfc3852edb514929eb26d5caa8c8dfd2ad838d3"
    sha256 cellar: :any,                 arm64_monterey: "15995e04d55abd6de39b92dfda9317df5fb5c026f3b6160d86734d7f8d3eeb4f"
    sha256 cellar: :any,                 sonoma:         "e49b89c77d9ef4df26b15a7ee090af02760687268d6d310418bcf962b605f30b"
    sha256 cellar: :any,                 ventura:        "826fc9a9f246980aa111decff7c3e05f31e635817f65386b4f40ce1fb7221634"
    sha256 cellar: :any,                 monterey:       "5cb5407a7c5cbb4c15b37658fd2e8e81c4774597136d46668778a180b8dbfbc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c83a6d546dd8852ead22a1442cbad2ae55b7d588e3e78196f763017fcda8db5"
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