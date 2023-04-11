class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghproxy.com/https://github.com/facebook/watchman/archive/v2023.04.10.00.tar.gz"
  sha256 "d6ae1e09cfc33393337c0f7a60b0dd7a122a4aec551bc73577e4ec5c936ae386"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f7db0cc7f158ea634f8661cf5fd09671ef06be1c37f071be9a069080d3594fad"
    sha256 cellar: :any,                 arm64_monterey: "59fc05e46ccae746cabd05993c8fe635258474e6449d72eeceb1c63f47a5ec62"
    sha256 cellar: :any,                 arm64_big_sur:  "aac8a8b3637369ebc36e9ab57a1f3784fed27e3667f0f0d7eec0e3418a4f0086"
    sha256 cellar: :any,                 ventura:        "8322faf7292f42262ae88cb300c299d67ae3e81ba87f1c1326a7217f04fd4592"
    sha256 cellar: :any,                 monterey:       "932391b1dde5145543a9137bce80922e659ffa4d8053b4615bd603818992ef7d"
    sha256 cellar: :any,                 big_sur:        "eeb3ed535a938f6f09b917805c15f97fd050d912cacc587edecacc0abae08a5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30caf873c3a0f9766e7a2ea4abfb1ab0c5dec2b91fa50d44e515f19e2806cd6d"
  end

  # https://github.com/facebook/watchman/issues/963
  pour_bottle? only_if: :default_prefix

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "googletest" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "edencommon"
  depends_on "fb303"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "openssl@1.1"
  depends_on "pcre2"
  depends_on "python@3.11"

  fails_with gcc: "5"

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace "CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 30)"

    # NOTE: Setting `BUILD_SHARED_LIBS=ON` will generate DSOs for Eden libraries.
    #       These libraries are not part of any install targets and have the wrong
    #       RPATHs configured, so will need to be installed and relocated manually
    #       if they are built as shared libraries. They're not used by any other
    #       formulae, so let's link them statically instead. This is done by default.
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_EDEN_SUPPORT=ON",
                    "-DWATCHMAN_VERSION_OVERRIDE=#{version}",
                    "-DWATCHMAN_BUILDINFO_OVERRIDE=#{tap.user}",
                    "-DWATCHMAN_STATE_DIR=#{var}/run/watchman",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    path = Pathname.new(File.join(prefix, HOMEBREW_PREFIX))
    bin.install (path/"bin").children
    lib.install (path/"lib").children
    path.rmtree
  end

  def post_install
    (var/"run/watchman").mkpath
    chmod 042777, var/"run/watchman"
  end

  test do
    assert_equal(version.to_s, shell_output("#{bin}/watchman -v").chomp)
  end
end