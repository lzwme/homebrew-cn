class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://ghproxy.com/https://github.com/mamedev/mame/archive/refs/tags/mame0259.tar.gz"
  version "0.259"
  sha256 "46baf431079a3373ffe8d984b3ba5d62ad5b1d5e356d1f60cf60f6ad03d4cec6"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/mamedev/mame.git", branch: "master"

  # MAME tags (and filenames) are formatted like `mame0226`, so livecheck will
  # report the version like `0226`. We work around this by matching the link
  # text for the release title, since it contains the properly formatted version
  # (e.g., 0.226).
  livecheck do
    url :stable
    strategy :github_latest do |json, regex|
      json["name"]&.scan(regex)&.map { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "06a632f8de0dfade1fe07e01855e3dd62780a9610585b3e4360f32cab08f4c91"
    sha256 cellar: :any,                 arm64_ventura:  "f169eb1c37061d423564989388f58ecf1d4c7214a45be438a0ee6845684df987"
    sha256 cellar: :any,                 arm64_monterey: "7451d9c185daf474f742eb63ae0f1ff83acfba038f0caaf774abd2a40c655e3e"
    sha256 cellar: :any,                 sonoma:         "e0649957cca9b4dc5045543f20520debd65af6ef109abf5c84b2ec71a85861bc"
    sha256 cellar: :any,                 ventura:        "c46bb21f50bcecc4f2f2b1c327df1a280cf3925ca391678a46a0cd80e2c002ae"
    sha256 cellar: :any,                 monterey:       "d4c4293afde70cb3471ec9f11d01e943437c6f44d47fbcbe7b0f999f428758bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f49d2dcd35ff4855f7938ffe5368f6ef7b229afe3ed3994809eb00d9a2630f4"
  end

  depends_on "asio" => :build
  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "rapidjson" => :build
  depends_on "sphinx-doc" => :build
  depends_on "flac"
  depends_on "jpeg-turbo"
  # Need C++ compiler and standard library support C++17.
  depends_on macos: :high_sierra
  depends_on "portaudio"
  depends_on "portmidi"
  depends_on "pugixml"
  depends_on "sdl2"
  depends_on "sqlite"
  depends_on "utf8proc"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pulseaudio"
    depends_on "qt@5"
    depends_on "sdl2_ttf"
  end

  fails_with gcc: "5"
  fails_with gcc: "6"

  def install
    # Cut sdl2-config's invalid option.
    inreplace "scripts/src/osd/sdl.lua", "--static", ""

    # Use bundled lua instead of latest version.
    # https://github.com/mamedev/mame/issues/5349
    system "make", "PYTHON_EXECUTABLE=#{Formula["python@3.11"].opt_bin}/python3.11",
                   "USE_LIBSDL=1",
                   "USE_SYSTEM_LIB_EXPAT=1",
                   "USE_SYSTEM_LIB_ZLIB=1",
                   "USE_SYSTEM_LIB_ASIO=1",
                   "USE_SYSTEM_LIB_LUA=",
                   "USE_SYSTEM_LIB_FLAC=1",
                   "USE_SYSTEM_LIB_GLM=1",
                   "USE_SYSTEM_LIB_JPEG=1",
                   "USE_SYSTEM_LIB_PORTAUDIO=1",
                   "USE_SYSTEM_LIB_PORTMIDI=1",
                   "USE_SYSTEM_LIB_PUGIXML=1",
                   "USE_SYSTEM_LIB_RAPIDJSON=1",
                   "USE_SYSTEM_LIB_SQLITE3=1",
                   "USE_SYSTEM_LIB_UTF8PROC=1"
    bin.install "mame"
    cd "docs" do
      # We don't convert SVG files into PDF files, don't load the related extensions.
      inreplace "source/conf.py", "'sphinxcontrib.rsvgconverter',", ""
      system "make", "text"
      doc.install Dir["build/text/*"]
      system "make", "man"
      man1.install "build/man/MAME.1" => "mame.1"
    end
    pkgshare.install %w[artwork bgfx hash ini keymaps language plugins samples uismall.bdf]
  end

  test do
    assert shell_output("#{bin}/mame -help").start_with? "MAME v#{version}"
    system "#{bin}/mame", "-validate"
  end
end