class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "https:mamedev.org"
  url "https:github.commamedevmamearchiverefstagsmame0270.tar.gz"
  version "0.270"
  sha256 "0364b670478883902c2bc618908192b0590235b47fbe073fcac2d13b82541437"
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
    sha256 cellar: :any,                 arm64_sequoia: "a5f6d0ce3a803521b8bc79c696710f1e8082b1dbd6f300ff83fa85a6341f760b"
    sha256 cellar: :any,                 arm64_sonoma:  "1d14b74aa317b639441e10af419c710bc64699c5dc5307e06c282acc4cb311f8"
    sha256 cellar: :any,                 arm64_ventura: "3262e28107395a3f37e0eb5bab7a03a2ccbc8529a16e612a0778788fdeb0d526"
    sha256 cellar: :any,                 sonoma:        "ca0bd3db9328bf9c7770e345640f29d7c78ff883aa78c777d79a97ee76c7d32c"
    sha256 cellar: :any,                 ventura:       "d3503cc5ac561ac073745c2da8d6d02f99c7839e6e271ff26b4ce00ed9ed4eb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d109ea136d2830d1439b0dd59bfa3dc5b12f011e9d8a0fb2ec1f5efbc628a8d"
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