class WoofDoom < Formula
  desc "Woof! is a continuation of the Boom/MBF bloodline of Doom source ports"
  homepage "https://github.com/fabiangreffrath/woof"
  url "https://ghproxy.com/https://github.com/fabiangreffrath/woof/archive/refs/tags/woof_12.0.1.tar.gz"
  sha256 "0dac95fe0e6ee6ac98f5f3eff4e28af42851e6ee3b2864a3f2ebfad9c51300b6"
  license "GPL-2.0-only"

  bottle do
    sha256 arm64_sonoma:   "97f32de8484c776cd3bbd74524c3d44b5b55889e35851eb6027dfe2c55b0bfff"
    sha256 arm64_ventura:  "13c63ed4b5de58013a212f7d37fbcdf29598fa85f84ab26624b9cfba373c6c4c"
    sha256 arm64_monterey: "adaea7e5364ca683dfb9ef3f901a6003d8863f7478dba04294c2f730b8ee72e4"
    sha256 sonoma:         "775d7a23903c618e6e3ee797922d43ade529ba6787c113dbb2ffab19a02c8b60"
    sha256 ventura:        "11405fb274aeb2ccfbdc5a88b610d1eb2df82a3624c0d5731c52da6c226b7cd6"
    sha256 monterey:       "792acf28474056af9ee12dbdcffcdba64300ef97cfdf6d59c00ff7b02f1f5989"
    sha256 x86_64_linux:   "abf0611639ad9912b65cd0d478c001b109843133a3f00a9f3436d7ff02bbae66"
  end

  depends_on "cmake" => :build
  depends_on "fluid-synth"
  depends_on "libsndfile"
  depends_on "libxmp"
  depends_on "openal-soft"
  depends_on "sdl2"
  depends_on "sdl2_net"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    expected_output = "Woof #{version.major_minor_patch}"
    assert_match expected_output, shell_output("#{bin}/woof -iwad -nogui invalid_wad 2>&1", 255)
  end
end