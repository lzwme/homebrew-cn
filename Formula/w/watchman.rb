class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  license "MIT"
  revision 1
  head "https://github.com/facebook/watchman.git", branch: "main"

  stable do
    url "https://ghproxy.com/https://github.com/facebook/watchman/archive/refs/tags/v2023.10.09.00.tar.gz"
    sha256 "f7e92f4007c151480f91b57c6b687b376a91a8c4dd3a7184588166b45445861c"

    # Add support for fmt 10
    # See https://github.com/facebook/watchman/pull/1141
    # Remove with `stable` block on next release.
    patch do
      url "https://github.com/facebook/watchman/commit/e9be5564fbff3b9efd21caed524cd72e33584773.patch?full_index=1"
      sha256 "dc3ef949b0a4be7dd67267eb057fb855926b3708e0ce1df310f431fd157721ca"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6f4022c251338bbdb496886775239f6cd023c354e2f79c98e93dcf899814b942"
    sha256 cellar: :any,                 arm64_ventura:  "c40872901c50bf34008609522898f6d06accf88bf9f588af1e4bd24c751774a1"
    sha256 cellar: :any,                 arm64_monterey: "d20e9567c275fcbd10a2afce4f97e0fcc9ae5e4179cbdafc91e8dba7f05aea97"
    sha256 cellar: :any,                 sonoma:         "35caf0c03ee34e2745260f18b3a0844c2a6f2dbc689db20c5a84664fd8041a5f"
    sha256 cellar: :any,                 ventura:        "8385d8184ffe1b3033f4f7d9e80f234e7251cbc466405e3055d40c8404dfa966"
    sha256 cellar: :any,                 monterey:       "a7dc2739b1ec9af8bdddeb77416079df84f4c285a697bf3af3a2c4185f406169"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80e056f44cc35f9480bd031b71a3ce4f5824ec106c0ec54eed18be8cdb95ba36"
  end

  # https://github.com/facebook/watchman/issues/963
  pour_bottle? only_if: :default_prefix

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
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