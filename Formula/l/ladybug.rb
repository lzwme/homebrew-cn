class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://ghfast.top/https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "5423aae21009fe76d2f8dad2d2453f02a2045bdbd0293e8bedd81c80ef0b6376"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e974cb2652ef10c55c4520cd8b021ac978a4c812f41d80e924ad1d95622cebdf"
    sha256 cellar: :any, arm64_sequoia: "718f434b780866782128da993e3d8fb76d961e7f3282d91450c236cbfef5a606"
    sha256 cellar: :any, arm64_sonoma:  "794073afbe2f2bacb76b970bcdd87489924c9aa414e7cc5d02abc831565211ac"
    sha256 cellar: :any, sonoma:        "f75b3a373dbfb8ca5f72e79df91743263d86b877acc6d2de6333301774e37951"
    sha256 cellar: :any, arm64_linux:   "ee097520ee72e7889208fa5bd0deaa861c755eb65e1a36901ce66c9c20dc53a1"
    sha256 cellar: :any, x86_64_linux:  "fc1f829c7991b2e6a61105651297c9257b3180bc12aa9676f749cb897e7bdae7"
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