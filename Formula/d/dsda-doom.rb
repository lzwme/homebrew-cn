class DsdaDoom < Formula
  desc "Fork of prboom+ with a focus on speedrunning"
  homepage "https://github.com/kraflab/dsda-doom"
  url "https://ghfast.top/https://github.com/kraflab/dsda-doom/archive/refs/tags/v0.29.4.tar.gz"
  sha256 "f866db79381862080718668f582b0f358811a016db17680e507abb9250afbea5"
  license "GPL-2.0-only"
  head "https://github.com/kraflab/dsda-doom.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "97abb02a08acd3c763e109e891b66148f2d6103a605f05813f7a55d0d7de0bcb"
    sha256 arm64_sequoia: "65be4eb9d9ec81c0c262449db661eb0905b7f67e1c97d552e76a52c34f5ad95c"
    sha256 arm64_sonoma:  "4e884d4536861319933dcd27ed383b39b2671457af6541dae5e08548c18bbb1c"
    sha256 sonoma:        "98ab1dbabeca9d84a81cbebab2b63a15f6525e44faa1807f94bf71ed52f84db2"
    sha256 arm64_linux:   "fb91560cb710053417fc102bff45242ccaf8f7acdbc3b20cde172a59214259a8"
    sha256 x86_64_linux:  "5c154ad60a1a8c093008eb446bd8512cbf8308e016c847274c55a7b54fe3fcd1"
  end

  depends_on "cmake" => :build

  depends_on "fluid-synth"
  depends_on "libopenmpt"
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
    root/"share/games/doom"
  end

  def install
    system "cmake", "-S", "prboom2", "-B", "build",
                    "-DDOOMWADDIR=#{doomwaddir(HOMEBREW_PREFIX)}",
                    "-DDSDAPWADDIR=#{libexec}",
                    "-DWITH_FLUIDSYNTH=ON",
                    "-DWITH_IMAGE=ON",
                    "-DWITH_LIBOPENMPT=ON",
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
    ENV["HOME"] = testpath
    ENV["XDG_DATA_HOME"] = testpath
    mkdir testpath/"Library/Application Support"

    expected_output = "dsda-doom v#{version.major_minor_patch}"
    assert_match expected_output, shell_output("#{bin}/dsda-doom -iwad invalid_wad 2>&1", 255)
  end
end