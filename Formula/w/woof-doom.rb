class WoofDoom < Formula
  desc "Woof! is a continuation of the BoomMBF bloodline of Doom source ports"
  homepage "https:github.comfabiangreffrathwoof"
  url "https:github.comfabiangreffrathwoofarchiverefstagswoof_15.0.0.tar.gz"
  sha256 "7e9bbdb54033afcb5c4347ee81e1cdef4fad94519f29c12af4bb554b5dad0b75"
  license "GPL-2.0-only"
  head "https:github.comfabiangreffrathwoof.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b0475fece5906321e68aee337d9cf206106b5ea0c019e3bec5bed85e30e0376d"
    sha256 cellar: :any,                 arm64_sonoma:  "581fc726a1cf219cc0e410f7ed886a5dfde5081cbb6821217a6eba73324895e2"
    sha256 cellar: :any,                 arm64_ventura: "e642bb23de591a31bc8e26b1a93fa5db09bde10781318eb22894a2a8297cd51e"
    sha256 cellar: :any,                 sonoma:        "8ad9f7d6b94541d52c0c4fd2405d22e0f4ef0d199afcf1a70fb528a5dca1d445"
    sha256 cellar: :any,                 ventura:       "fb2f21edfab0a38f51041b24725760d62989bc574ad4764fca1c3a0e55f4fbd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d019a46534edd35758cd78e8699d7a1d832538860c2247e9870f47692584d3eb"
  end

  depends_on "cmake" => :build
  depends_on "fluid-synth"
  depends_on "libebur128"
  depends_on "libsndfile"
  depends_on "libxmp"
  depends_on "openal-soft"
  depends_on "sdl2"
  depends_on "sdl2_net"

  on_linux do
    depends_on "alsa-lib"
  end

  conflicts_with "woof", because: "both install `woof` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    testdata = <<~EOS
      Invalid IWAD file
    EOS
    (testpath"test_invalid.wad").write testdata

    expected_output = "Error: Failed to load test_invalid.wad"
    assert_match expected_output, shell_output("#{bin}woof -nogui -iwad test_invalid.wad 2>&1", 255)

    assert_match version.to_s, shell_output("#{bin}woof -version")
  end
end