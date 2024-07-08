class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "https:mamedev.org"
  url "https:github.commamedevmamearchiverefstagsmame0267.tar.gz"
  version "0.267"
  sha256 "c6dacd02080ab20512a7d15fc6a1715879912d7482df6b4d5f36849e1ae5813f"
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
    sha256 cellar: :any,                 arm64_sonoma:   "dbc49f88f95a756c9adf66ace1753be1a05bc5d42dac36e9d386600fd9959c0a"
    sha256 cellar: :any,                 arm64_ventura:  "b4d2855a4d63d7c30a8b0ae90d813dfccda79c4f33444516fde169f91e503a3b"
    sha256 cellar: :any,                 arm64_monterey: "380dabbfbcc99b6f4933f2b98753fd5fb5ef6061442672b18980f0b951770749"
    sha256 cellar: :any,                 sonoma:         "232b2e9e80c30cfba204fcd62c3d00d749cdd8bc2a6493d9fff7adbd4064bf72"
    sha256 cellar: :any,                 ventura:        "ed711aef6ed678782ed4e10cdbe289c9372c1aa0aacf436ef26d8c7d4dce068e"
    sha256 cellar: :any,                 monterey:       "5c712d8159c97d98132793e99a17529bde103c354c4046c5614709da7a4d54ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a01c37616f8dfb2d9fd0796b521f7f948968b01f681ec8942dafda69c135efe6"
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