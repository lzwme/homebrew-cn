class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghproxy.com/https://github.com/facebook/watchman/archive/refs/tags/v2023.10.30.00.tar.gz"
  sha256 "57ff2a308e27c245e3e4795a81b446254b3bc699cb88786123ef19501712ba5f"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "af8ea34df75162843517f14f7e52a4519ad0ed4432e9173d442e5cfa33c4f3f2"
    sha256 cellar: :any,                 arm64_ventura:  "c111f3027724e77180c24b8df64cbcbefe643a873db724f268a8607e43b349d3"
    sha256 cellar: :any,                 arm64_monterey: "9f9c2c1bc98d117025bb175ebb240c21d9551487d80d8b925cd5b0181914c493"
    sha256 cellar: :any,                 sonoma:         "ac2833583555503769b41fd969a23025f78360390f6682786e2cd031c6238103"
    sha256 cellar: :any,                 ventura:        "e005e3f5c70a8564253efb7474c7f59758d8d1abcd8790bf70974379c78d773a"
    sha256 cellar: :any,                 monterey:       "71f792b039514a6ea18678cd66912e29b20fbf163791a6cf31307c547aa3ca9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d2f19c0b9b01610b0bcda38ce3f04223a7a3a6ef8c3eb5eaabc79dc778343d9"
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