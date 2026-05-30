class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://ghfast.top/https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "143a1e9559d401589120dd6437b817c7e971990caa64c6270bca388412fde733"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "67a57bb7b161ced470861c8c92a968c3fc31711d2aa9a3633f9344122cd55594"
    sha256 cellar: :any,                 arm64_sequoia: "10646d0d0d29e8fb6ca3d2cd41cdfd6c9a5443679e21773cd3ea340415885081"
    sha256 cellar: :any,                 arm64_sonoma:  "c1022342a20b5e2a79b5b18ad7d4f109f7e8a2bfe676a9594619b3336b3678b5"
    sha256 cellar: :any,                 sonoma:        "e7721840bcf93fcbe85659b3b286e98d455e4b5d0308b4630acea10bd6214b09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a35a761e0d809908cedb91382d73afa24c0f0fd94f3ba2b191a6f51640749219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "973f1c7f221048ba9cdfc285fb3c29087e8c5f4b3f1b5379b6413bf0f4ef0da0"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  on_linux do
    depends_on "gcc"
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