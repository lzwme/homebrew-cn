class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghproxy.com/https://github.com/facebook/watchman/archive/refs/tags/v2023.11.20.00.tar.gz"
  sha256 "1f17d329a00a66744ef6f0fb558fd276988a3d96b46df8fd2fde8f1773278d68"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a4d6fcf03938ff8ad62305646f8eede304921586f237af7120884ede0ce5adb7"
    sha256 cellar: :any,                 arm64_ventura:  "6fe1e9d8efac20263fe01d5d6b7ffeb036ac1ba2ddff4cbf9bab4538a1e360a3"
    sha256 cellar: :any,                 arm64_monterey: "26c3407cb0d22300276c0878b80c268d9d2328bbab7dd8ff83c9185c731a736a"
    sha256 cellar: :any,                 sonoma:         "4a6e805cff7f84ac982b81fb28cdec90160889d9096ac8eff31b03bc206409b9"
    sha256 cellar: :any,                 ventura:        "78bf5572a7291ed91cc65a6a581c0150a70ed3f2f967d25dd7a1b46242caa60f"
    sha256 cellar: :any,                 monterey:       "c939b0134c58fe68117ecf1ecc0dda93ec2bc516fe50d16f1454eafbfbf1109d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d5ecba406f26f4cf74838fe8375174add2a554146bd930a4565ed001fb4a9c8"
  end

  # https://github.com/facebook/watchman/issues/963
  pour_bottle? only_if: :default_prefix

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "fbthrift" => :build
  depends_on "googletest" => :build
  depends_on "mvfst" => :build
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
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.11"

  fails_with gcc: "5"

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace "CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"

    # NOTE: Setting `BUILD_SHARED_LIBS=ON` will generate DSOs for Eden libraries.
    #       These libraries are not part of any install targets and have the wrong
    #       RPATHs configured, so will need to be installed and relocated manually
    #       if they are built as shared libraries. They're not used by any other
    #       formulae, so let's link them statically instead. This is done by default.
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_EDEN_SUPPORT=ON",
                    "-DPython3_EXECUTABLE=#{which("python3.11")}",
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