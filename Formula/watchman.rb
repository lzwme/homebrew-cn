class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghproxy.com/https://github.com/facebook/watchman/archive/refs/tags/v2023.06.08.00.tar.gz"
  sha256 "d4f772d67932e64a699c85f0c79a9be4e15fe493f0a15655908d88e7d0d39279"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a44d998faf2c70c24f932b0f4a2c26440961f4a4580de28b48a9c04da89b94bf"
    sha256 cellar: :any,                 arm64_monterey: "957d365a76658df5f02b0731bf816e5de0d6f4bed96d22b6c84a323ad99b68d5"
    sha256 cellar: :any,                 arm64_big_sur:  "17b2d4118ff607291daf160e03985dbb9ab027314f819aea70ea883ee5d98e64"
    sha256 cellar: :any,                 ventura:        "acb0e34c77bdaa46ad3ac1e77dc4e520f5c5b670f53bc48182bd29c7c2a19939"
    sha256 cellar: :any,                 monterey:       "92da535349fb1580b329ba88513740b82ba2f192d6c673eee09bb39334880feb"
    sha256 cellar: :any,                 big_sur:        "1d8870598d56f0d8bbc46d8e1d993178ed333397026118a9e817ff674c6be6bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c8f67e62e5dd35f4a4e4f7d1cf59e705cd4d07c348192a6e135cf113bc0b835"
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