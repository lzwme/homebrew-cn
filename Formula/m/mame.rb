class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "https:mamedev.org"
  url "https:github.commamedevmamearchiverefstagsmame0269.tar.gz"
  version "0.269"
  sha256 "05df2e82ff1d157282a5a667a67aa6eb331c55a64138afad0e8ac223553088ca"
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
    sha256 cellar: :any,                 arm64_sequoia:  "6092f8e361b4b6ac8e3003291d91b6169c9ee8092b23c3547546c9443a79ed1a"
    sha256 cellar: :any,                 arm64_sonoma:   "c4029304e0a87b30c989cca377926378819b6155f04fc49792232f04f3d233c0"
    sha256 cellar: :any,                 arm64_ventura:  "e76a22a0aff40d0f5a25f79f0a8d926d53ead453673b0bd36e3a8a289a6b7135"
    sha256 cellar: :any,                 arm64_monterey: "687dceaacb047e1430f9246a751f15c85c9ac8f3662f2e2baafe33f7a339ef6f"
    sha256 cellar: :any,                 sonoma:         "bb77d0cb57150a03d664c4fdab882e3d7c0838bab9fe6e61edaf1074185b6473"
    sha256 cellar: :any,                 ventura:        "541018f6c7ab8f64b4966730bb835d271b9aa1e72227ef32ca2c38a55e43739f"
    sha256 cellar: :any,                 monterey:       "769bc37f936fa3a3c570e793c1c252de2f6820c34b45439e6c89e6e026e9eec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b5eed510a3ae71ed13976e9aa1281ed5c039a126dd5a47ff103ac8679aef932"
  end

  depends_on "asio" => :build
  depends_on "glm" => :build
  depends_on "pkg-config" => :build
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
    depends_on "pulseaudio"
    depends_on "qt@5"
    depends_on "sdl2_ttf"
  end

  fails_with gcc: "5"
  fails_with gcc: "6"

  def install
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