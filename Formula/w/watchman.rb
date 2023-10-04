class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghproxy.com/https://github.com/facebook/watchman/archive/refs/tags/v2023.10.02.00.tar.gz"
  sha256 "a37900e7fae549253fb58d4007f90bdcca05565b7dd55cee7c748d055ed8399c"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ed6c808e90c1c7b183c190b4c5133b6fabeb48be5e32cae72c930f63ba0102af"
    sha256 cellar: :any,                 arm64_ventura:  "b783f22287e0d1e2789c23b577dda762c627252143561a7a14f6df85376014af"
    sha256 cellar: :any,                 arm64_monterey: "ef8e391050cb9e70256d06cb9e54573f16f73bf4eafab2b176ab8c7771aacd92"
    sha256 cellar: :any,                 sonoma:         "d5ccb79ff0f984220a10139febee4651e1594511ffdaaff6d7a5451fd6c87863"
    sha256 cellar: :any,                 ventura:        "6a0107c8af1a7a8c90af99452fe673de2874ad6c44fdbe96ffba64e1b11fb693"
    sha256 cellar: :any,                 monterey:       "7bfc4209ad3fe1ba19748f3536813327791042cb0876704772dcf03d550bce28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da1a733cafba31469978e25e1131a833ae93d6c9c39f4a74eb6fc163c27a6715"
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
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"

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