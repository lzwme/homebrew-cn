class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://ghfast.top/https://github.com/fluent/fluent-bit/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "c28a88c492473f43016ced0f21be1f5e3083a31af42c17eae0360c4917ac084d"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1590d64f81b918e5932ee9805978ce9bf7558c992d05679c7e7c3ec46e936c40"
    sha256 cellar: :any,                 arm64_sequoia: "079eef27a14f5ded043b2e59a684891ec56a09556bfdf278da9a8020201c0774"
    sha256 cellar: :any,                 arm64_sonoma:  "3ba7134744533f8f06030fc1b310186433656c9388b05f12ddb49f5c107fad48"
    sha256 cellar: :any,                 sonoma:        "916bb54a66e5a1f8a8e8e14c5d687c06ff138fa046828d4a66bb941e9cdaed43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05d441a138b209f840b9bdf211f811874ba96ecfb14ee6a55b786c81802db623"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e24b20784ca94bb527d086430c52e5e08251c519dd279ab2f32470dc646fa953"
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