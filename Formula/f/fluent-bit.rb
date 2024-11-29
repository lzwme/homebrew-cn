class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https:github.comfluentfluent-bit"
  url "https:github.comfluentfluent-bitarchiverefstagsv3.2.2.tar.gz"
  sha256 "3abcd7eda1a26fe79f1d715491bafcca77d0186cc46d1d8465157790358f827d"
  license "Apache-2.0"
  head "https:github.comfluentfluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "af89d2a66e1e668cb3ba357373ab986ea64e39a09cc18968feb5db295776cb87"
    sha256 cellar: :any,                 arm64_sonoma:  "86f22d5dbda4363a14e71ed1de1be7f26d8d03bbc1d4c0da057b5a0a2d052db7"
    sha256 cellar: :any,                 arm64_ventura: "ecea648bc9c45ad2598bd2c2d4a46e295922dad232475cf7174be6114f8823c4"
    sha256 cellar: :any,                 sonoma:        "09a32f1ed146c6ab1f4727d3c88915edc7a7fa56002b96ebe742751ac601ff0e"
    sha256 cellar: :any,                 ventura:       "2d497b67f90eb42621d2b45880afc8b7e03ba5c718f57ab084584b866e031983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1ed19978a87c0cd15ea46b8c85f99e2560e3ffd343ce4aae5855abdb768bad2"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => :build

  depends_on "libyaml"
  depends_on "luajit"
  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    # Prevent fluent-bit to install files into global init system
    # For more information see https:github.comfluentfluent-bitissues3393
    inreplace "srcCMakeLists.txt", "if(NOT SYSTEMD_UNITDIR AND IS_DIRECTORY libsystemdsystem)", "if(False)"
    inreplace "srcCMakeLists.txt", "elseif(IS_DIRECTORY usrshareupstart)", "elif(False)"

    args = %w[
      -DFLB_PREFER_SYSTEM_LIB_LUAJIT=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}fluent-bit -V").chomp
    assert_match "Fluent Bit v#{version}", output
  end
end