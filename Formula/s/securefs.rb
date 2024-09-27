class Securefs < Formula
  desc "Filesystem with transparent authenticated encryption"
  homepage "https:github.comnetheril96securefs"
  url "https:github.comnetheril96securefsarchiverefstagsv1.0.0.tar.gz"
  sha256 "de888359734a05ca0db56d006b4c9774f18fd9e6f9253466a86739b5f6ac3753"
  license "MIT"
  revision 7
  head "https:github.comnetheril96securefs.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f39657d2fb5f1e9f624a45126b82d76b4d185f584fb9c2b9969f353a7564a554"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "tclap" => :build
  depends_on "abseil"
  depends_on "argon2"
  depends_on "cryptopp"
  depends_on "fruit"
  depends_on "jsoncpp"
  depends_on "libfuse@2"
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
    system bin"securefs", "version" # The sandbox prevents a more thorough test
  end
end