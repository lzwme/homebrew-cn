class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://fluentbit.io"
  url "https://ghfast.top/https://github.com/fluent/fluent-bit/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "d230548fa3bb18d3d918f6b886530fb32380d609411c2959c358bda6a7702fb2"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bb2387068a7a022b92200156a866e3b6b3bc22f6e4e248076eb699737e28bbf7"
    sha256 cellar: :any, arm64_sequoia: "2b128204e0c4d436e84e49a85ea40236550fe55f7a9e463e1f14aef10d736591"
    sha256 cellar: :any, arm64_sonoma:  "5e7e3cd7dbd338ce989e257a2be4bea2dffb357661a0bdcc15cfbd1090d36198"
    sha256 cellar: :any, sonoma:        "4856e53c03cdff30116f96ba31dd8d46801c789c3e05ea6b6a271b0ab50129f1"
    sha256 cellar: :any, arm64_linux:   "bb265da92e2034707f87fee9d03dbbeb37ef7a1e6f147f7e8b5d9c00f8684ce2"
    sha256 cellar: :any, x86_64_linux:  "b42078ab6490ef45db322e5c4fe3b49efb6525cf9ba37ed1f191343dac24ba5c"
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