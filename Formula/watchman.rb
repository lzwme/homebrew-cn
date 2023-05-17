class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghproxy.com/https://github.com/facebook/watchman/archive/refs/tags/v2023.05.15.00.tar.gz"
  sha256 "3eb08eb7fc0397f4b44d360ae2f2efc1b579e6d467ba346747aa0b08bde295c8"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cd62d515c1d31b0ace7205e65c02245105077a843565c31911590d736d3be871"
    sha256 cellar: :any,                 arm64_monterey: "435e0fece5e66678085b1980f828d550117a22ca70f646dc20765ac0d359e5cd"
    sha256 cellar: :any,                 arm64_big_sur:  "1b7ad8cef2fbd349c85743904f0c5b992f7ad5f22b0a523b85066d830290e8bf"
    sha256 cellar: :any,                 ventura:        "274912640a5d26ba652dfb941171e54778b7dca22a346368ca11fb6803b0a08a"
    sha256 cellar: :any,                 monterey:       "9e0b03125c2cf792d871eebe61445c6b84ed555b651e4bbef67892bb49997f1a"
    sha256 cellar: :any,                 big_sur:        "718a25ad4fab03b29e1b89cafd7fad93ebf99f3d42c5ab70b37ff47a863f0a0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbe04f94d512471ca5cfeaf70264eb9d1d4be0ef426fc6f1f6b72bf72b44de6f"
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