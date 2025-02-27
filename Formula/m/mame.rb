class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "https:mamedev.org"
  url "https:github.commamedevmamearchiverefstagsmame0275.tar.gz"
  version "0.275"
  sha256 "cf12c3c40a94f7bc67deefa69923a0769f99b66dc15bd7e2505b3130df6130bb"
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
    sha256 cellar: :any,                 arm64_sequoia: "cde5c4c9086b30b46a862dacab7a85c44f85246928ec82650fcf29515d745213"
    sha256 cellar: :any,                 arm64_sonoma:  "9cbbbce480f117e5ced2d114b7fd6b5e463bae29d6f4b94f60e0926b95b7e45a"
    sha256 cellar: :any,                 arm64_ventura: "dbd90d72fc8ed65adbe4cd7591ce96e942b8c6ac4670eb8902efc1a5c409fdb3"
    sha256 cellar: :any,                 sonoma:        "d52021dc0aad1d81095f714e9dfde4bd5d383860d40193126a85bf2ef461eb0f"
    sha256 cellar: :any,                 ventura:       "659a0f4f7ddfda75091100ec1309f2bde86c33844fb2659abcb3f17ecfa073b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4962bb878309d05b218839d41920f950043459b51ec0b37792d582f2c016093c"
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