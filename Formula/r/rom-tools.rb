class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "https://www.mamedev.org/"
  url "https://ghfast.top/https://github.com/mamedev/mame/archive/refs/tags/mame0285.tar.gz"
  version "0.285"
  sha256 "2b7ed1553ddf434692f62ded87b296931968d55e15f786a8588102880851f41c"
  license "GPL-2.0-or-later"
  head "https://github.com/mamedev/mame.git", branch: "master"

  livecheck do
    formula "mame"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d31797f7ef2978b9764cd249e45f05440e91586ca0a61dcfdc9219f1194a825c"
    sha256 cellar: :any,                 arm64_sequoia: "86cae030e7e29d1d7c4eca5af3b1a1ffbb8b646a0a46fe0da768438c264f5351"
    sha256 cellar: :any,                 arm64_sonoma:  "a4a1e43f5dd79dc8c9b391ad0b28478d6df6c4f12004718c5e51e7c274a9dd89"
    sha256 cellar: :any,                 sonoma:        "6abd153f6b61bf2554ed86676c3690d6d176aaf6aeae66b4a96c55035950988f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "979d102c1bb386a037d806a5f5acacb06a8450643ed5aad8e111f59480256149"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb7411f1d6cd2251410fbce7b78c561b8a804a2769a59fac4fb3f261a1dc269c"
  end

  depends_on "asio" => :build
  depends_on "pkgconf" => :build
  depends_on "flac"
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
    depends_on "qtbase" => :build
    depends_on "sdl2_ttf" => :build
  end

  def install
    ENV["QT_HOME"] = Formula["qtbase"].opt_prefix if OS.linux?

    # Cut sdl2-config's invalid option.
    inreplace "scripts/src/osd/sdl.lua", "--static", ""

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
    man1.install Dir["docs/man/*.1"]
  end

  # Needs more comprehensive tests
  test do
    # system "#{bin}/aueffectutil" # segmentation fault
    system bin/"castool"
    assert_match "chdman info", shell_output("#{bin}/chdman help info", 1)
    system bin/"floptool"
    system bin/"imgtool", "listformats"
    system bin/"jedutil", "-viewlist"
    assert_match "linear equation", shell_output("#{bin}/ldresample 2>&1", 1)
    assert_match "avifile.avi", shell_output("#{bin}/ldverify 2>&1", 1)
    system bin/"nltool", "--help"
    system bin/"nlwav", "--help"
    assert_match "image1", shell_output("#{bin}/pngcmp 2>&1", 10)
    assert_match "summary", shell_output("#{bin}/regrep 2>&1", 1)
    system bin/"romcmp"
    system bin/"rom-split"
    system bin/"srcclean"
    assert_match "architecture", shell_output("#{bin}/unidasm", 1)
  end
end