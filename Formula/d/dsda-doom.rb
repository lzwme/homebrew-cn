class DsdaDoom < Formula
  desc "Fork of prboom+ with a focus on speedrunning"
  homepage "https:github.comkraflabdsda-doom"
  url "https:github.comkraflabdsda-doomarchiverefstagsv0.28.0.tar.gz"
  sha256 "c6efc8d68cc0e9fa2facd2b608779383fcf3a8322edbdb8d7433f0c2adf5a483"
  license "GPL-2.0-only"
  head "https:github.comkraflabdsda-doom.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "9a28b37636d1fe85145f55680ed4639693106c71147697a17713e92e9459c47e"
    sha256 arm64_ventura:  "417ff87ad041d7b8103260cb8d92877a3be55caad546a6693d4423e7783aa60c"
    sha256 arm64_monterey: "cb81f3486c84dc6004c2db531f520c7b835d2d4cb43499f62b6d955fe023d9cb"
    sha256 sonoma:         "79e7b443bb33e68fcafabbd159c3f4ed7c009659424fb26454bf182aa3aa782e"
    sha256 ventura:        "94618366de545884460dfad7f917d24d7fb618c3ef5887e572b0e67d20a32be2"
    sha256 monterey:       "f52066e7d6aa87d9015fbe06666b1155863bc42069e1e3826ce99acfca04dd8b"
    sha256 x86_64_linux:   "b92b9bbc24f88ee8d64f07bbbf9751877912662344dbe157fdc6f5168cfad2c4"
  end

  depends_on "cmake" => :build

  depends_on "dumb"
  depends_on "fluid-synth"
  depends_on "libvorbis"
  depends_on "libzip"
  depends_on "mad"
  depends_on "portmidi"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  uses_from_macos "zlib"

  on_macos do
    depends_on "libogg"
  end

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def doomwaddir(root)
    root"sharegamesdoom"
  end

  def install
    system "cmake", "-S", "prboom2", "-B", "build",
                    "-DDOOMWADDIR=#{doomwaddir(HOMEBREW_PREFIX)}",
                    "-DDSDAPWADDIR=#{libexec}",
                    "-DWITH_DUMB=OM",
                    "-DWITH_FLUIDSYNTH=ON",
                    "-DWITH_IMAGE=ON",
                    "-DWITH_MAD=ON",
                    "-DWITH_PORTMIDI=ON",
                    "-DWITH_VORBISFILE=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    doomwaddir(HOMEBREW_PREFIX).mkpath
  end

  def caveats
    <<~EOS
      For DSDA-Doom to find your WAD files, place them in:
        #{doomwaddir(HOMEBREW_PREFIX)}
    EOS
  end

  test do
    ENV["XDG_DATA_HOME"] = testpath

    expected_output = "dsda-doom v#{version.major_minor_patch}"
    assert_match expected_output, shell_output("#{bin}dsda-doom -iwad invalid_wad 2>&1", 255)
  end
end