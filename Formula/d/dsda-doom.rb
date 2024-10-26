class DsdaDoom < Formula
  desc "Fork of prboom+ with a focus on speedrunning"
  homepage "https:github.comkraflabdsda-doom"
  url "https:github.comkraflabdsda-doomarchiverefstagsv0.28.1.tar.gz"
  sha256 "31f6c8a8707625ff8f47c65d4821fca59b084d1153d0ac2aa215dabc7108a91a"
  license "GPL-2.0-only"
  head "https:github.comkraflabdsda-doom.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "bacfaeac66a0fd8e690d5f31d10ad4bdbce5604697621ce794b05e92f8d3caa7"
    sha256 arm64_sonoma:  "43b06c5a9dae4d1aa0ecd808632a514d936eaf454938669bb4a2ca829f59f60a"
    sha256 arm64_ventura: "4ccd31d4faadc9668c18f76dce66b15cbf4a3d532ba5eb70bacac9f12635c975"
    sha256 sonoma:        "8d51672c564f29c99dde26a2467891d694f2b20cc5583533cef73422b834ee9a"
    sha256 ventura:       "5388a5838ec2cc16b00dead941cdbe0fef94932a9dab8a062ff2ab5a24771f76"
    sha256 x86_64_linux:  "218b49d3cd11dc7e8e7edfce04f537ae7c223460a09679b5bcb5b4bfbc0810b4"
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
    ENV["HOME"] = testpath
    ENV["XDG_DATA_HOME"] = testpath

    expected_output = "dsda-doom v#{version.major_minor_patch}"
    assert_match expected_output, shell_output("#{bin}dsda-doom -iwad invalid_wad 2>&1", 255)
  end
end