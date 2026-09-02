class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://ghfast.top/https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "c4dc6844479a799247f0cdf749522bb7597b78a97b90dbde0706601b207c928f"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "520a0de76435832a11633a1ef6b8fb88ae4d6e375e5f49e8bbb2759a445fba90"
    sha256 cellar: :any, arm64_sequoia: "a67663c6e22dc85853a5e7c5a726cd8b89255c0676ee483bf7adb2051202ecf1"
    sha256 cellar: :any, arm64_sonoma:  "6f92b650cfcc8241ce4ea4c2949ce5885674559c1fbe4890269e4b1d3ce9bd7d"
    sha256 cellar: :any, arm64_linux:   "f4e1de849f0a3ba8fb708e25dcf1428f5db7fc8532c867b1f1aa8cac36ec41ee"
    sha256 cellar: :any, x86_64_linux:  "942549c5ed70cc58614e47bcc2f428a05b0a627f61ff8d52dcb4dd37d5dcd2ca"
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