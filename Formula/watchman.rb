class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghproxy.com/https://github.com/facebook/watchman/archive/refs/tags/v2023.07.24.00.tar.gz"
  sha256 "abef7859e6412a30f92941d811a0ef7e595a0ef8bfebb674f909743fdc3f5a46"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6e5848bfd3d3d51ff979aaa7dc9f83bfc71eb4bc9519603c99d97e7edfe9c10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15925e861f1785554018aafed9a15f0ab2aae44f9dbe58e1c8b87cf4caac422e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "049d2ba6f024c32d94ab0faf19a843bf889357b1a2da21adbb9b4f193dba9d44"
    sha256 cellar: :any_skip_relocation, ventura:        "bb40ed9bf286944d4a6386f03b58316d82b700bf79a218a8da5f0bfd968f23e8"
    sha256 cellar: :any_skip_relocation, monterey:       "0e3d0fab12eab2abee6a51a4902fc880661050fe519f6746d27c5f931a9f16aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "233f9baf964df837c94ffd379ef8dc38532453be6b6c9b21343fb4e1d7924a18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f0517286e57719fd9d4b4995c33d95f19a84ae028d3b065620c6bafb323ecfa"
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