class DsdaDoom < Formula
  desc "Fork of prboom+ with a focus on speedrunning"
  homepage "https://github.com/kraflab/dsda-doom"
  url "https://ghproxy.com/https://github.com/kraflab/dsda-doom/archive/refs/tags/v0.27.3.tar.gz"
  sha256 "956194c5dbbd8be5b62ca93cb975a6dbacdfc3ca97165c4da65a07843092b297"
  license "GPL-2.0-only"
  head "https://github.com/kraflab/dsda-doom.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "79e0a149b36a2744db6e99f043f0503e940b9b5daee84a3c77f761f3a504a5ca"
    sha256 arm64_ventura:  "059658977bd226dbfcfc443c1698a98d2baf3033df7597bcf764d697fdb24e4a"
    sha256 arm64_monterey: "6e52af1fcb426e1ff0a26867765dd20cd45cf00d6ef5bac35264cfc7efa77894"
    sha256 sonoma:         "877c04f45966133fab62f15e1c305ceb23c1b1bf291b5e8a7a03cd73ef264854"
    sha256 ventura:        "de56cae227d0ec1fa44974910c7334b840331a649b446e3776d645c2c2fb96bc"
    sha256 monterey:       "1a9220638d88c8d25563d9c59ab64ee83a7b4b11b3983673d0cb419a8fa5519f"
    sha256 x86_64_linux:   "dc193e61c7be0beb0d18748d149f2ce0c92ac234e5a0381fcd2a04d2bf592b0c"
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