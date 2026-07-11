class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://ghfast.top/https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "667748cdd962ad7bf33d765f2c00a896e32f7982ea23594a9ca99b26aa53f046"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "363cb2fb8c8ea8ed050e59b8b5819623dde81bc92c6d8de47a74b5ce6a9dd148"
    sha256 cellar: :any, arm64_sequoia: "2b0e90f51eadd82457657dbfa5cc5c7e7e136d2e252b56e6521cbee754ac991c"
    sha256 cellar: :any, arm64_sonoma:  "14ac74eaa50810cda5385c75545a141fb8facd66406af7438695beeca92693d7"
    sha256 cellar: :any, sonoma:        "95d2ced78e6f4609b323ef74de0b6bebf710441b09da1008446e55d5f69f9b3e"
    sha256 cellar: :any, arm64_linux:   "a64e6779b174144480f8c406025184fe3f58093566ebecb1b2e1cb2089ae27e9"
    sha256 cellar: :any, x86_64_linux:  "9da3fc4b2ac4828fe96256fed1d3fbfa86af98c5afbef60c4ea225e4533fb5eb"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1600
  end

  fails_with :clang do
    build 1600
    cause "Requires C+++20 support for `std::atomic_ref`"
  end

  fails_with :gcc do
    version "12"
    cause "Requires C++20 std::format, https://gcc.gnu.org/gcc-13/changes.html#libstdcxx"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Remove unwanted headers and libraries for `cppjieba`
    rm_r Dir["{#{include},#{share}}/cppjieba/*"]
  end

  test do
    # Upstream versioning up to patch version, so skip for 4th number in version
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/lbug --version")

    # Test basic query functionality
    output = pipe_output("#{bin}/lbug -m csv -s", "UNWIND [1, 2, 3, 4, 5] as i return i;")
    assert_match "i", output
    assert_match "1", output
    assert_match "2", output
    assert_match "3", output
    assert_match "4", output
    assert_match "5", output
  end
end