class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghproxy.com/https://github.com/facebook/watchman/archive/refs/tags/v2023.05.15.00.tar.gz"
  sha256 "3eb08eb7fc0397f4b44d360ae2f2efc1b579e6d467ba346747aa0b08bde295c8"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "1278de20ba255d8c2ac227b74b321bfc0f18e9d8f6229e7876af2e9f007056b9"
    sha256 cellar: :any,                 arm64_monterey: "b8061f023992cd614194ed910aa71520dbdb2b8c13deca4131c57714340165d0"
    sha256 cellar: :any,                 arm64_big_sur:  "53881af3ad6c86ad40eb6516ec98e59e64d1d6c16920e4462ee78d63763d5e40"
    sha256 cellar: :any,                 ventura:        "506b80151d1f2de38404449092d04081e175fb6782cecb56dea326ec3c6ca127"
    sha256 cellar: :any,                 monterey:       "729d8af5b74b8b1fb055d44f04e565e2c333587be2cf946d3307c41ada9266cf"
    sha256 cellar: :any,                 big_sur:        "9e08dc2bb5c946f02a18b68a08bc53243050f2cb6a76a3f2c791f4a505915721"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d58798209d9c3964ee3ca9e131633abf99b55449ac50ee69b51a036fa9be2ae7"
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