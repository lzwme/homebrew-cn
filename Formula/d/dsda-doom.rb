class DsdaDoom < Formula
  desc "Fork of prboom+ with a focus on speedrunning"
  homepage "https://github.com/kraflab/dsda-doom"
  url "https://ghproxy.com/https://github.com/kraflab/dsda-doom/archive/refs/tags/v0.27.4.tar.gz"
  sha256 "a514f33ad60449c7ae48fc6eb4b407dd23fd1160c3bba890cb45bc60ad57288d"
  license "GPL-2.0-only"
  head "https://github.com/kraflab/dsda-doom.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "cf3ff9b5f21441eb69e81122613b6bb383e3aec74a862bb5882e53aa56c6e47d"
    sha256 arm64_ventura:  "199e5ba71a52e80ba7fc578644aa5022ea8495bec20231924e62b945130c173c"
    sha256 arm64_monterey: "6ab5405db6b37fa0432895bdbd81116830a8cd726e68b1960bcd734dbefd9aa3"
    sha256 sonoma:         "bd2c583599a4bf389e57dfe57b94a4621cd037400d2c5e6a2471a4090154d2fd"
    sha256 ventura:        "4fc342691daec3d55736531c7d36cc9197e9811925ef93c30e969375d0ed0e12"
    sha256 monterey:       "f20f37ee6248e03fff532a34eb4bec764cc09bdb8d63c57c99b4dd2f90683edd"
    sha256 x86_64_linux:   "0b2d27d07208d584d78d9fde8c2ec5e4e44171575b9c781d78bb3b3e595d0529"
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