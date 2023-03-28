class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghproxy.com/https://github.com/facebook/watchman/archive/v2023.03.27.00.tar.gz"
  sha256 "5863af2355ac0cd3b950f415df8eb7a1d41d2a9cd394c60cd31e6b864f4e0d35"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "704f6422a57d79b2428ef1b69ff71845b378650ac7c84d890ca582697b1d4cc7"
    sha256 cellar: :any,                 arm64_monterey: "4eb7992fade9f8c805c32194dee3fbb06518915f6338d3e893712d5a326a08cd"
    sha256 cellar: :any,                 arm64_big_sur:  "92dcfac22675b2a685f4dc83c7f9801671f9a9196457a3c36379884370f5de3f"
    sha256 cellar: :any,                 ventura:        "520d19a40dcb575b73ae8e116ff581eaf7bd5dfb1594189f0133ef4d1c4aa8af"
    sha256 cellar: :any,                 monterey:       "508d79b0c379fecdb2e8fa74d3b8c9f606787e0b00460f39ad43c063745329ec"
    sha256 cellar: :any,                 big_sur:        "cc172368d7f1ef8afbc861698cb9ccdd0857ae7c11b0fae04b521ecf8195e55b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac3d048a94ed857066384f8a074aa00303b9df53da1ad81e197aae41baba9d4e"
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