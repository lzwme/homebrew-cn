class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "https:mamedev.org"
  url "https:github.commamedevmamearchiverefstagsmame0274.tar.gz"
  version "0.274"
  sha256 "f8112eb0b175935cf6db93f708186dcaeec5a89400ecf3d5782fd2c0b94907c8"
  license "GPL-2.0-or-later"
  revision 1
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
    sha256 cellar: :any,                 arm64_sequoia: "df96f4ed544700a481418f37cddded41737fe0f4c7fa3531debebf43894b7df8"
    sha256 cellar: :any,                 arm64_sonoma:  "eb900cf58e7273d4cbf6b56db9450b9f55792c178bd59a604616af7b7f416544"
    sha256 cellar: :any,                 arm64_ventura: "dde05d2b69f5265b1e35d3f3d47aadfefd8d27fa1b8acdd01cf99534cb4601cb"
    sha256 cellar: :any,                 sonoma:        "dcfc48ffed46e6589f09325470d5937549366707078fb3a1b484b928b4f7b6e0"
    sha256 cellar: :any,                 ventura:       "8ce5209294d93493b8abe10b567f718280542ba604e03a172dfcb52308166920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1aeb6d2228745e067b60a97975f9361faf0aaa75b7450f99b9ad10d19779bc0b"
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