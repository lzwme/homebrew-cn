class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://ghfast.top/https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "a2c96c779c3d01fb4d648cab5a676f9d7ab1497a5eaf6e02576dc6738f6b1108"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ecdd0ada9c667fd7aafba22dd8d4523db92b8c3b33cd64f7f1648fcce8a45759"
    sha256 cellar: :any, arm64_tahoe:       "a0d6296aa2380f665be9617748f0e338ff123961159aebeb059443636ef67cb1"
    sha256 cellar: :any, arm64_sequoia:     "91c05ad69d4f3dc6de36a131472c484ff90115ca89ebd619862f356af399ed64"
    sha256 cellar: :any, arm64_linux:       "4a397459fc001c44bb66b51ac04edfce9a69cc5d7625ffbd4cb45b20e3f49104"
    sha256 cellar: :any, x86_64_linux:      "069a1cd8d439ac7a64b7eeccbf0e03c3b518a48667ed41ae05d522f1874cb64a"
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