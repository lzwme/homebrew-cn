class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://ghfast.top/https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "04b3ca8b826c41cbc103c8523a6bc0734c79003104f51c8df5230c9f551c1212"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0d7a80db19e6d57220b667d20982fe5fa6e5f615ddbcb3051236eeb92f0eb5ab"
    sha256 cellar: :any, arm64_sequoia: "2b98b5dd52a2def6554cd3fdb7393e3f4d5998b878de469d5209a746f13a2c43"
    sha256 cellar: :any, arm64_sonoma:  "81a92a45e9213b320f84fde1270dbde42b434f9e70ac69a9478545d432f44d56"
    sha256 cellar: :any, sonoma:        "8faf1678a7e72e3528e7b552d8282c5d814c503726368656d0220575f5e90a56"
    sha256 cellar: :any, arm64_linux:   "ec0b59b54b53289a986c42970aac65921b93a7a07f8cfdcf2b748cf7208651de"
    sha256 cellar: :any, x86_64_linux:  "a781d0e47da5dbb2e376b0347275ac241caeb3ab546778468a5183c04dde845e"
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