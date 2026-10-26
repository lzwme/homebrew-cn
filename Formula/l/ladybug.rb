class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://ghfast.top/https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "b0f7a92aaa852cbb8615393011a0eb8801a32e3bc26e7974d0b65bf4c569b377"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6c5f1bf311de91c8b73daf991f7df56b7ea6538d23a6f2100afb2e1083c3dd35"
    sha256 cellar: :any, arm64_tahoe:       "f15274bc03e7fd26204bd4f2dc1b369173c5ee1d947e90822c3eec6e9f8906cb"
    sha256 cellar: :any, arm64_sequoia:     "bdcf96a7abc914f7a901d58da3f0122faec8020d4d5e16f825481ac4c0b9b129"
    sha256 cellar: :any, arm64_linux:       "cb192f7246db76c823d0a5f6b89cd45c55c50b99f0c973391b96e07481c95f92"
    sha256 cellar: :any, x86_64_linux:      "8f10f4da97f7a558d589aea5dd3939b496a2957696f3e948a48422a21724a2a4"
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

  deny_network_access!

  def install
    # Upstream pins OpenSSL 3 only for their CI `-Werror` and wheel packaging, while the code supports OpenSSL 4
    inreplace "CMakeLists.txt", 'if (NOT CMAKE_MATCH_1 STREQUAL "3")', "if (CMAKE_MATCH_1 LESS 3)"

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