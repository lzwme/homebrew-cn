class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://ghfast.top/https://github.com/fluent/fluent-bit/archive/refs/tags/v4.2.1.tar.gz"
  sha256 "1310797832fffc29a257fbc21e25460274a9442d4e63047971ee354898ad5075"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "861f288056efc8338041e4043c3a5b7abf8e1b85ee53b2ed79020510c0dd3fd7"
    sha256 cellar: :any,                 arm64_sequoia: "85f88bae9ecd0bbde877b3104e9abf21ff0016c52445930182895243d165d877"
    sha256 cellar: :any,                 arm64_sonoma:  "4bd11a08cb32f5556a9f82b4a5cc161666555b2a70ea1165e8aae3c743598d4a"
    sha256 cellar: :any,                 sonoma:        "7601c00f7667124ab5c3c8c5503a3756639f87b5610180227fbe70f1a2f2edd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41a5fba5b18a7c49f6427ba389f9892b42229af407d474a8c0350ed65eb7386c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76e81247d361724c0a1437a20e31b8cd229eb03e2c19186242805ea3be583119"
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
    # For more information see https://github.com/fluent/fluent-bit/issues/3393
    inreplace "src/CMakeLists.txt", "if(NOT SYSTEMD_UNITDIR AND IS_DIRECTORY /lib/systemd/system)", "if(False)"
    inreplace "src/CMakeLists.txt", "elseif(IS_DIRECTORY /usr/share/upstart)", "elif(False)"

    args = %w[
      -DFLB_PREFER_SYSTEM_LIB_LUAJIT=ON
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_match "Fluent Bit v#{version}", output
  end
end