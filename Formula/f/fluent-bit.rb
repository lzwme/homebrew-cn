class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://fluentbit.io"
  url "https://ghfast.top/https://github.com/fluent/fluent-bit/archive/refs/tags/v5.1.3.tar.gz"
  sha256 "cc7de4fca3e08bce2cee5b82ddff512118e08ceb63fcdb433dbf49f1a43586fb"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e89e95a95b9f1a2689bfe93c2398612a28927d7eb13373f52e1387e02ce22d37"
    sha256 cellar: :any, arm64_tahoe:       "191c06dbec088e856620f4aa6c4286f5403ddfdfff667b88eea476b60ef4e158"
    sha256 cellar: :any, arm64_sequoia:     "1e665194dfceedd3ddeb53b4c66aa34e987daf7e2726372844748afe0b846fb3"
    sha256 cellar: :any, arm64_linux:       "f0f99cd9677857761ed451538a398e7188c922302b04f235508aa5847c6b0992"
    sha256 cellar: :any, x86_64_linux:      "e2e77854fc436520804f6a0f67e9a6113759be4b998652bd9685f9697c6b7f74"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => :build

  depends_on "libyaml"
  depends_on "luajit"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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