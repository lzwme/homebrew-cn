class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghproxy.com/https://github.com/facebook/watchman/archive/refs/tags/v2023.05.15.00.tar.gz"
  sha256 "3eb08eb7fc0397f4b44d360ae2f2efc1b579e6d467ba346747aa0b08bde295c8"
  license "MIT"
  revision 1
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "21a819758320354a01a55f2f0f165599d017be261512c2ce573540a6815238dd"
    sha256 cellar: :any,                 arm64_monterey: "bd9d7980b75723668a07211cfce942555cd285b889b7936e908cf8094e8364df"
    sha256 cellar: :any,                 arm64_big_sur:  "a2bc92c9891b93ab909ebb19fe0b2f4837db5dfc6c01c84225be09e0c00fcc8b"
    sha256 cellar: :any,                 ventura:        "7ea422a77f185586083f6484aba7a91069eff5a92d38d2c4155fd403c663ade8"
    sha256 cellar: :any,                 monterey:       "e1654cfc6970c1c5c9f55ff18328caa61b056d0684db4ecdd11d3afbc0c9ebc5"
    sha256 cellar: :any,                 big_sur:        "7fcc32cab3b0cc8dcdabf00fd219ecb8bdd67d255c8dc0bf5ffcbf87351e049e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "803fee39400c6aab823216f81821a072de8058368ac814f2ff15d6d38784222c"
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

  # Add support for fmt 10
  # See https://github.com/facebook/watchman/pull/1141
  patch do
    url "https://github.com/facebook/watchman/commit/e9be5564fbff3b9efd21caed524cd72e33584773.patch?full_index=1"
    sha256 "dc3ef949b0a4be7dd67267eb057fb855926b3708e0ce1df310f431fd157721ca"
  end

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