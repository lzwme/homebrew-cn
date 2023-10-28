class DsdaDoom < Formula
  desc "Fork of prboom+ with a focus on speedrunning"
  homepage "https://github.com/kraflab/dsda-doom"
  url "https://ghproxy.com/https://github.com/kraflab/dsda-doom/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "fae2698355ea9d75355936e2d63236e3d3a86f1cec5a07eca0cff09d9d17c57a"
  license "GPL-2.0-only"
  head "https://github.com/kraflab/dsda-doom.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "e810d39d37366df172aa0c913731033922a0eafc8dd9f3cbb955375eb58a0363"
    sha256 arm64_ventura:  "efa39ea12a259ef366eaff5bda490568b3681d620945dec5274d22c24a570a29"
    sha256 arm64_monterey: "68b325f1806f7148d0b813ec67dfa78857c97742cc7d88891972b001f78d5491"
    sha256 sonoma:         "a76b04437e56dee7bff60bd21ebf52c3eb2b4625fd1ceae07f9db720d6ffb0ce"
    sha256 ventura:        "5a6b36ed7137cef238a24c79d44a788e5266c25537b706c0fcebd2db92c49cd4"
    sha256 monterey:       "accafd8645fee7201edf62d901d69f3cefd4d9bc8edf3fd57e829aef1ce90bab"
    sha256 x86_64_linux:   "7eae24c67acd6a71715568d3f2832919fdff38e5e1b846bb2c51e3bba20dc6fc"
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