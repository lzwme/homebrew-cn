class DsdaDoom < Formula
  desc "Fork of prboom+ with a focus on speedrunning"
  homepage "https:github.comkraflabdsda-doom"
  url "https:github.comkraflabdsda-doomarchiverefstagsv0.29.2.tar.gz"
  sha256 "0f1950d6b2974f00d1a2d23128f59fc7afac904939b7f275a4e44e4775d14ecc"
  license "GPL-2.0-only"
  head "https:github.comkraflabdsda-doom.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "6a367777f6c777f7dba7736363f9e29071b99d9ef08d81541b793246fcb3e5b0"
    sha256 arm64_sonoma:  "c6750ccaebc6cbc544694435784739cb912c8342eb237d36434b847cb4328a24"
    sha256 arm64_ventura: "ac9062632042cf0e7091d2e2774b0ec55f6f1e1379ebdc1688e6ea4f57e1c4ba"
    sha256 sonoma:        "96c0d3b07a26ad050ac8455fb4b23bc90d53eaebdae5b483c114d55e8fabe2c6"
    sha256 ventura:       "7d764812e4607579d77ee0ae2dbd4c4f8fdfd47d6d9709cc685b99b768c4cc6b"
    sha256 arm64_linux:   "c249c1c6021ff328a3eb89a2a12c66d0f8d6f5ad9574ee13d03fc465ced438a9"
    sha256 x86_64_linux:  "fc130906d9fc84220c81559bb06c01a63ddc07f4d9fb8bddeb2ed2d2a5df9572"
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
    mkdir testpath"LibraryApplication Support"

    expected_output = "dsda-doom v#{version.major_minor_patch}"
    assert_match expected_output, shell_output("#{bin}dsda-doom -iwad invalid_wad 2>&1", 255)
  end
end