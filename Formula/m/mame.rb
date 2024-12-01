class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "https:mamedev.org"
  url "https:github.commamedevmamearchiverefstagsmame0272.tar.gz"
  version "0.272"
  sha256 "cd83bff2f8acf72bdb105ba8e899b49ad09c25cee8a8a063ae27a954fe0dc097"
  license "GPL-2.0-or-later"
  head "https:github.commamedevmame.git", branch: "master"

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
    sha256 cellar: :any,                 arm64_sequoia: "5b3d0b0a70b4fbe87a0b1be72dd530b9b1927dbe32d9f445d7167bca64271e49"
    sha256 cellar: :any,                 arm64_sonoma:  "4b20360c7119d3d90b66225ca8124eff3a032c10fc6225e8259d1f663f5c1edd"
    sha256 cellar: :any,                 arm64_ventura: "2dd924b1b09c38a89227de8e606ed72227b6ddf8b78198deca0a68130dc9bb25"
    sha256 cellar: :any,                 sonoma:        "9e89f3702b21fa5cd85a349361e7db9b17e8c1a7d1b0df93a772265a67b2c073"
    sha256 cellar: :any,                 ventura:       "3a5c90e76bf7b5bb6378eeaad7f2ac06696f7dead616ece30821d677b48007c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2cfc92bb19608f8425886c945ef7e48426587989c3e51e9f3d2869edb289b73"
  end

  depends_on "asio" => :build
  depends_on "glm" => :build
  depends_on "pkgconf" => :build
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
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    depends_on "fontconfig"
    depends_on "libx11"
    depends_on "libxi"
    depends_on "mesa"
    depends_on "pulseaudio"
    depends_on "qt"
    depends_on "sdl2_ttf"
  end

  def install
    ENV["QT_HOME"] = Formula["qt"].opt_prefix if OS.linux?

    # Cut sdl2-config's invalid option.
    inreplace "scriptssrcosdsdl.lua", "--static", ""

    # Use bundled lua instead of latest version.
    # https:github.commamedevmameissues5349
    system "make", "PYTHON_EXECUTABLE=#{which("python3")}",
                   "USE_LIBSDL=1",
                   "USE_SYSTEM_LIB_EXPAT=1",
                   "USE_SYSTEM_LIB_ZLIB=1",
                   "USE_SYSTEM_LIB_ASIO=1",
                   "USE_SYSTEM_LIB_FLAC=1",
                   "USE_SYSTEM_LIB_GLM=1",
                   "USE_SYSTEM_LIB_JPEG=1",
                   "USE_SYSTEM_LIB_PORTAUDIO=1",
                   "USE_SYSTEM_LIB_PORTMIDI=1",
                   "USE_SYSTEM_LIB_PUGIXML=1",
                   "USE_SYSTEM_LIB_RAPIDJSON=1",
                   "USE_SYSTEM_LIB_SQLITE3=1",
                   "USE_SYSTEM_LIB_UTF8PROC=1",
                   "USE_SYSTEM_LIB_ZSTD=1",
                   "VERBOSE=1"
    bin.install "mame"
    cd "docs" do
      # We don't convert SVG files into PDF files, don't load the related extensions.
      inreplace "sourceconf.py", "'sphinxcontrib.rsvgconverter',", ""
      system "make", "text"
      doc.install Dir["buildtext*"]
      system "make", "man"
      man1.install "buildmanMAME.1" => "mame.1"
    end
    pkgshare.install %w[artwork bgfx hash ini keymaps language plugins samples uismall.bdf]
  end

  test do
    assert shell_output("#{bin}mame -help").start_with? "MAME v#{version}"
    system bin"mame", "-validate"
  end
end