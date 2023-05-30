class DsdaDoom < Formula
  desc "Fork of prboom+ with a focus on speedrunning"
  homepage "https://github.com/kraflab/dsda-doom"
  url "https://ghproxy.com/https://github.com/kraflab/dsda-doom/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "2cae87531db025813314ea09dbe75937f398f7b2c65839be0640409ff7cba02e"
  license "GPL-2.0-only"
  head "https://github.com/kraflab/dsda-doom.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "04eec357f4b28b39af1f9bbb4d0ae216b57ac198b6c4e58043f6832122d65054"
    sha256 arm64_monterey: "70d53986785d931c916ec0840baea81ddba120dd619cb8b908459b30be1a5a97"
    sha256 arm64_big_sur:  "4d318e6edf1ca32d70e413553208538c9d6c88a37ba1aae84395e244e4948f88"
    sha256 ventura:        "8ee068847010d3133507ee775e4e94593012723fd105e18373a437f28642f9f0"
    sha256 monterey:       "93b0627bfe7220c0a804cfdfeebe68ee27fc599dfb0a629bf1cc6f794cbf0d87"
    sha256 big_sur:        "3baaf72f8ca0fe9e6188699f46200650f303f63a0f67dcb91b7b6664bddf4803"
    sha256 x86_64_linux:   "152fea208dc7fc834714606952fe4c447813a45c813c445a89ea3380724f64eb"
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

  on_linux do
    depends_on "mesa-glu"
  end

  def doomwaddir(root)
    root/"share/games/doom"
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
    expected_output = "dsda-doom v#{version.major_minor_patch}"
    assert_match expected_output, shell_output("#{bin}/dsda-doom -iwad invalid_wad 2>&1", 255)
  end
end