class DsdaDoom < Formula
  desc "Fork of prboom+ with a focus on speedrunning"
  homepage "https:github.comkraflabdsda-doom"
  url "https:github.comkraflabdsda-doomarchiverefstagsv0.28.2.tar.gz"
  sha256 "5cab9227a5ab1c6fded71321c2d9ae2b481e8defc7f04ea9ca232cb13b856ce6"
  license "GPL-2.0-only"
  head "https:github.comkraflabdsda-doom.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "db6649329c85718257a641fe1e7fb9786aeb269b472117f4c46c8e225476507e"
    sha256 arm64_sonoma:  "672879822807be377967aed7039acac226ca7da4242f49f04f697a7cd4bc7bb5"
    sha256 arm64_ventura: "4fc7d8a2c44c191d1d6eb0d679dbdb38ce63b0d76858fea613bf1fe4edeecbb5"
    sha256 sonoma:        "5eb2c7e28e9c677dbd6d2b70e6ac704c9f90d809e04cf06133f9101130a685a6"
    sha256 ventura:       "263b370dcd5a634a5eae6cfe4f0f14ccf5e121cd4750806912616e9d30973d8b"
    sha256 x86_64_linux:  "bea4d211577ca8450b598010d90ab9f915918bcc7ecbb80bd1d8ff63688029f9"
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