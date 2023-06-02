class DsdaDoom < Formula
  desc "Fork of prboom+ with a focus on speedrunning"
  homepage "https://github.com/kraflab/dsda-doom"
  url "https://ghproxy.com/https://github.com/kraflab/dsda-doom/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "c81882328a75bf26489bdf35beff831070badc3df7d9799378418dcbdd9d2769"
  license "GPL-2.0-only"
  head "https://github.com/kraflab/dsda-doom.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "163511d3de62251f5b1346e646771adafca7497731e6e8953f71d7db89c37fc1"
    sha256 arm64_monterey: "eca83f14961808d7c7649f9e0877aa6db4403d586ac1b2791ef508f7a4c9bd1f"
    sha256 arm64_big_sur:  "a0fc6864ae006f676d14550f59f543a400bedbe20b60f14397ca3ceedf88ba96"
    sha256 ventura:        "476c658a6c77f0f2170aaafe46a6fda024e8bd2d7d4b0b9f5456986cd47640c7"
    sha256 monterey:       "b0f325c773d3bc26af316893bd43fca0724527a78dcaf84ac25344674ee779a0"
    sha256 big_sur:        "c1ac541c11e1ed8b3dba3e3cb64cc5e04912d66f5e0dabb3b5811ac978784192"
    sha256 x86_64_linux:   "5e209e5df54b0efcdac0e930d8b4632b9996128cdcc5f923e23fef79a84cf9bf"
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