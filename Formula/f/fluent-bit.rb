class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://ghfast.top/https://github.com/fluent/fluent-bit/archive/refs/tags/v4.0.5.tar.gz"
  sha256 "514ca092e286f21441f6d4754f2ca26875a82ff930c0a4d17e6efda93d9ba5c5"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "514584ddd334c6aadefb93c9baa2e11f794f0ba89dfa9a25e87ab388aa746cb8"
    sha256 cellar: :any,                 arm64_sonoma:  "ecf5bc349bb806580eb92ca199439908bd45fb57311d6e1ebed17cbc3c0e022c"
    sha256 cellar: :any,                 arm64_ventura: "af31a9726f9986752ba73c9dcd68d585b9d9967aeec42eacd10daa42e4242a93"
    sha256 cellar: :any,                 sonoma:        "87717b774a10c79134736adb703e280b4367ec9c72eb127d9deaf4279d142b41"
    sha256 cellar: :any,                 ventura:       "c2ae2b44be6afa75d697ada0e7c971727cef3e6a078b4a832922c3b49619554b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4de9bf842433419b58b96b1380b73e46aa41deaab59c9fdb08bfc5998d33529c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "061f2c4956cd2360fb234fb7009a47aee63453c8e145d45b192c82fb81da9d4c"
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