class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghproxy.com/https://github.com/facebook/watchman/archive/refs/tags/v2023.07.17.00.tar.gz"
  sha256 "877fc1c88028134c6c1541f797a8c25a0d333088b292c914ce7f589339ddf0fd"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49e13cf018f863471871a7b07c5aeeddd66eb20708d80c41610594c2ddfb611d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f38164694cf18695b561842e694d232208b938dc4ddc667dda065186c26aaaf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "621fd828495a984af22ebbcece914de0ebc9d51e9445a9030a9a266095566a6c"
    sha256 cellar: :any_skip_relocation, ventura:        "a9dc62eccc725bf6e5a6e0e67a8fd2806bd45c85192851ebaa58fa6f5763baf0"
    sha256 cellar: :any_skip_relocation, monterey:       "82646d057fbdac17bc2938e760cbc41951f74a79cae58d447d05385b0b1317ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "46f3a504b4957267f8aec225ba9340a69c4299a692e9a62535f1522b8091c680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cebee4afc63cdad19fd12bab78ad1ae921afd7c3eb493e90a8a3537def45311"
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