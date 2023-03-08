class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghproxy.com/https://github.com/facebook/watchman/archive/v2023.03.06.00.tar.gz"
  sha256 "5e9fcb2d8293e89d66ef0585a20bd20d786bb79abba61ebced260d5f4168d223"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2151710e3128b7e48145cd7845a87a16caa230a9040062a836ec86869b40c518"
    sha256 cellar: :any,                 arm64_monterey: "e31956430ad35495b63e49d6c49e9885ef685f3509c28deadd091bbd376f43c3"
    sha256 cellar: :any,                 arm64_big_sur:  "a54bc5b28d827e87f73f01f84a55de57708edfb27a856c1e2252c243b821f183"
    sha256 cellar: :any,                 ventura:        "4a68e3b667c8278d3cfabd2b50677b3617b5b48110c4777a87e89f724264997b"
    sha256 cellar: :any,                 monterey:       "56d3b73d26045ae8b07313e35bdeaa46c2a34a560fb8736f7ce739a16bf102d3"
    sha256 cellar: :any,                 big_sur:        "004e59e27f6c523d30f4b95ef5bc2742157c39c11147e498778201504d1e773f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b4cdf0f184ebefda0853a07c137afd0e9786d33fef1656e04c2cbd190ac87e3"
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