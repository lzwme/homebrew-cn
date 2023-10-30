class DsdaDoom < Formula
  desc "Fork of prboom+ with a focus on speedrunning"
  homepage "https://github.com/kraflab/dsda-doom"
  url "https://ghproxy.com/https://github.com/kraflab/dsda-doom/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "caa16845cd3a2273dce8b71ff55f463183724788a6850a5012e694956f94cd80"
  license "GPL-2.0-only"
  head "https://github.com/kraflab/dsda-doom.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "eb9e6d514b98c4349b7a6061e50c6589265fb84a6305dd97012fbbe08c2f05f5"
    sha256 arm64_ventura:  "48548246b67953ff72dd0e014a3c33d7207242ace2a770cf6c87d742e3de5783"
    sha256 arm64_monterey: "1ea2f2877a9108623b58e6a8d84f3f29b16e7a131c715ba28981422602f9268d"
    sha256 sonoma:         "7379c3edb59a0ae5401d6c29e407d485d0e3c5c3a4dc437917511ff3189ed602"
    sha256 ventura:        "0907d2db65bd550c236ae18bfe41f9f86f91d0d9211014c3ec2f339afad5b6a5"
    sha256 monterey:       "ffc6f84d6dd74a1f692b58d0f8ec286749235f6ab5693914567c67ba5df61f11"
    sha256 x86_64_linux:   "e37ff871aded0ae84881ed2df336245d31e78cd0d0a8e0abb21411bd6ffb6dcf"
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