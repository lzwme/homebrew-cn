class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https:github.comfluentfluent-bit"
  url "https:github.comfluentfluent-bitarchiverefstagsv3.2.1.tar.gz"
  sha256 "8e706a2bbde85260f7df0638084e56d64a7149aa1bb67c5816bb5bda0bb928ab"
  license "Apache-2.0"
  head "https:github.comfluentfluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "79596fead7be0aedb84259d3faa6e6486e7acfd92fa69fcde67b9c139950287b"
    sha256 cellar: :any,                 arm64_sonoma:  "9257daf1370c0834fad3cea318b808908393f9485d757a7e5d25f89e804ed4f4"
    sha256 cellar: :any,                 arm64_ventura: "6c79091cac29e43a70e2350d33aad6d97956ac25f8f5e7a89edd07193147d707"
    sha256 cellar: :any,                 sonoma:        "255bef3b3278aaa77779f1838da05a3fc695aad23d8474046ec26d1e4df83390"
    sha256 cellar: :any,                 ventura:       "ab8c1ca181aa2899c931391ec128a7dc6c074dcd61d8978466bba9ed48bd0a8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8437e0f10f87dc8c3c2e8706ca7e1a039efae7b343a5874d80b071c1fdc43d3f"
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