class Securefs < Formula
  desc "Filesystem with transparent authenticated encryption"
  homepage "https://github.com/netheril96/securefs"
  url "https://ghfast.top/https://github.com/netheril96/securefs/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "d7fac7adc70c09473173aeadee5b7041d7e63fbf392ef40bdd77888590bb12a2"
  license "MIT"
  revision 1
  head "https://github.com/netheril96/securefs.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_linux:  "bd090ea6c88ee49ea828fb2fe4756ddd0a3d15975a911abd42ada53338f39d2c"
    sha256 x86_64_linux: "2a160b2c4720a6be867f6f072993dc7f708b6b44908821710fa58c63078deb9d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "tclap" => :build
  depends_on "abseil"
  depends_on "argon2"
  depends_on "cryptopp"
  depends_on "fruit"
  depends_on "jsoncpp"
  depends_on "libfuse@2" # FUSE 3 issue: https://github.com/netheril96/securefs/issues/181
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "protobuf"
  depends_on "sqlite"
  depends_on "uni-algo"
  depends_on "utf8proc"

  def install
    args = %w[
      -DSECUREFS_ENABLE_INTEGRATION_TEST=OFF
      -DSECUREFS_ENABLE_UNIT_TEST=OFF
      -DSECUREFS_USE_VCPKG=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"securefs", "version" # The sandbox prevents a more thorough test
  end
end