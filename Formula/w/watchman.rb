class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghproxy.com/https://github.com/facebook/watchman/archive/refs/tags/v2023.10.23.00.tar.gz"
  sha256 "34ec8f9fa744190c9effac22f5f9684cf323743fb9f77c64318ad0cde02d136b"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c5102f923ed521b373851e674fa899080f71665d4ea74cae6dc09affa7b2e555"
    sha256 cellar: :any,                 arm64_ventura:  "93738deeb35e7ec65550692f1b1522964b546130c3d018246baa9ef4663b7291"
    sha256 cellar: :any,                 arm64_monterey: "99b1e1d4edd6e0c824bedc965e4129078cbf7d12af54cc0848aaf148ce155cbd"
    sha256 cellar: :any,                 sonoma:         "5f285afccf5031b821061fcc15533c4ee0d062318c644471dcfa755c2eab1265"
    sha256 cellar: :any,                 ventura:        "b90c0ee5bf0b6be2eef673bc3295820071ddf4e3ec69399d0fdcb78c28a5a5e8"
    sha256 cellar: :any,                 monterey:       "71f989f3afaaae9a1123112124ddefa3cbb9764607f6b062a2db097a6edf582c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6aa74c3a835334cbb946c04319edb6903d85dd19ca738e5822e5a8d5809e63dc"
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