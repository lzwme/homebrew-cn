class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghproxy.com/https://github.com/facebook/watchman/archive/refs/tags/v2023.05.01.00.tar.gz"
  sha256 "2310431903afc8f8d034ef6664366e362f5beb8fccf15e4355ad61c63596c4b1"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "59b91c7ff771faa3ed65b4e8d143676215881676275022ff4398c49378bb5efd"
    sha256 cellar: :any,                 arm64_monterey: "a7880fec8e30d26167569d898d4f87b1a61f75be9a7dd1fe495fff380f771dae"
    sha256 cellar: :any,                 arm64_big_sur:  "4bb86bf83fb3383078bf9ab8cd4889329df379b3b7b47c7db27b189ce6f7a57e"
    sha256 cellar: :any,                 ventura:        "763dab129732d7a220b4ba853e1529568a92e5ec107e88cfadad8a610d7005c2"
    sha256 cellar: :any,                 monterey:       "4af59dec55383d62cd3adb1652213ff81ff257a4ed92f56260a420c498f5adae"
    sha256 cellar: :any,                 big_sur:        "ec0f2cdab8352f32ddb4c369488b3d2ba5ee252e087532934137d2d990b9cbf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f151b7308e221e523ac6f45dd6983a7563dce367fad3a8496c7620a99e2541db"
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