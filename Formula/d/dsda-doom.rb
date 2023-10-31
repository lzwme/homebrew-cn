class DsdaDoom < Formula
  desc "Fork of prboom+ with a focus on speedrunning"
  homepage "https://github.com/kraflab/dsda-doom"
  url "https://ghproxy.com/https://github.com/kraflab/dsda-doom/archive/refs/tags/v0.27.2.tar.gz"
  sha256 "29071be8fffde4df2834026f40c5b6a268e00e43453d9255314601be9c336445"
  license "GPL-2.0-only"
  head "https://github.com/kraflab/dsda-doom.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "78143f8ab731975fb41c63cc622fc6b5ab4fa2a9495267ae20821bda44594530"
    sha256 arm64_ventura:  "a0bd67a12f96f97c837445e7e55848ee1e2db721a316a62fa69702df4a3a27cc"
    sha256 arm64_monterey: "d361ce5fc583c269b6cff243bd0a128a4fcb310de2495ce1de7479f0507f8b5f"
    sha256 sonoma:         "040407f59925d2e5171a3fb9e6450aee52f1ae52926e25a40f73ea25675b279c"
    sha256 ventura:        "7f8fa63caa7655d2a90890a126ca6d074b846879edaf5738e07d4ea0d214fcab"
    sha256 monterey:       "3ee6aded7b7a412f757736b36f1f9777e40f428b1095326a5abebf5c5449256f"
    sha256 x86_64_linux:   "631a2912ab00cccd9cf61263d42482022b736f206eeca2a1c5ba9b3975f37504"
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