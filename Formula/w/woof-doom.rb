class WoofDoom < Formula
  desc "Woof! is a continuation of the BoomMBF bloodline of Doom source ports"
  homepage "https:github.comfabiangreffrathwoof"
  url "https:github.comfabiangreffrathwoofarchiverefstagswoof_14.1.0.tar.gz"
  sha256 "ad619f8b15b9fa0e690fe8094f394d4d1b3e7b7c3935317aac2f631835a09626"
  license "GPL-2.0-only"
  head "https:github.comfabiangreffrathwoof.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "08447a9daeb32166a3a2aa3fa9c1c8278d816b23be65be63e22bd3a40f6fbae1"
    sha256 arm64_ventura:  "6aea63feef1f1aa7f6de8404b72ae100e5f09b74fd4e22d9686bad50fda1e783"
    sha256 arm64_monterey: "91da832c40992a685e30861157bdc1df5fa670588a70ac7da3156aaa1987f9e2"
    sha256 sonoma:         "14dc5a19d51d3f7b11d960caa0db6c9bc1dbfdd736b79e2dc0f3b3e4b04a25cc"
    sha256 ventura:        "693aaa05819468b70aa11b4067e797a10bcea1c3f0a8a80869c930fbb55bea04"
    sha256 monterey:       "70db5fc738874388c0c26955fe4291b41cb660f48031a72b42b9e476db26cc6d"
    sha256 x86_64_linux:   "286ac5e777eb93ac0d39511030e64d710cec6903f50cf811ec5f5d47c5900672"
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
    testdata = <<~EOS
      Invalid IWAD file
    EOS
    (testpath"test_invalid.wad").write testdata

    expected_output = "Wad file test_invalid.wad doesn't have IWAD or PWAD id"
    assert_match expected_output, shell_output("#{bin}woof -nogui -iwad test_invalid.wad 2>&1", 255)
  end
end