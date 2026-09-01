class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://ghfast.top/https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "cacec89bd105d8f0da73537054e471e818c983cf9b453e79ca17bd5d7afaefbe"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b623634cb3524613692bca7ea39493dbb23bde367230a74d0a637fd8bf893a9f"
    sha256 cellar: :any, arm64_sequoia: "0b4f4c75b1b13dbb0ec77def6b9ae9120fac9159e1e96b0c09cad22dcae1051d"
    sha256 cellar: :any, arm64_sonoma:  "ca1dcef665fa4390284873715ae179f1cd6357ff50bb8bae574b331f595a35bb"
    sha256 cellar: :any, arm64_linux:   "53e3f9a5df3cea48ae5182eae74c8ce68186a5426c394ab07773e68c6f663214"
    sha256 cellar: :any, x86_64_linux:  "733a3daeb8aaa232d43b99d66ab6a608ea31b88491f539d9fcce950d567971db"
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
    args = %W[-DCMAKE_INSTALL_RPATH=#{rpath}]

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