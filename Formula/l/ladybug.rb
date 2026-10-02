class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://ghfast.top/https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.21.2.tar.gz"
  sha256 "8b3f98df08a6a1a37ff9a45dc32f83b0a52fb063082b7875d9518654775ac150"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3f253977d3fbbfb6551725804ea777d5a5400ef532d67d012e1e8872b47a12c3"
    sha256 cellar: :any, arm64_tahoe:       "8c83494e82720e39d6c190be45e4c60461dffcff163c46a296e79268b0f8b928"
    sha256 cellar: :any, arm64_sequoia:     "5656a5725cf65d50e40cae2fea219776f0e818e5aee106f7bd78572c1b7b19f4"
    sha256 cellar: :any, arm64_linux:       "97bdfbf8dcae492a3ffe1ef3cf46ca121b5f6a61cc8b6da74bc79ed8bd4c21eb"
    sha256 cellar: :any, x86_64_linux:      "c57d3f889924b5fb256449b87ad8442a90c4cfd6f902aba49be8594e52642929"
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