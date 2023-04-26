class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghproxy.com/https://github.com/facebook/watchman/archive/refs/tags/v2023.04.24.00.tar.gz"
  sha256 "46633adc0eec8870e0cde420cc5b17834e196bdd760c1c977efc6d1eeb104b13"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6e3608f34b852b7387eba9a18419ae2a52110d7b8d9e4822f36d7ed04814ddad"
    sha256 cellar: :any,                 arm64_monterey: "316a2d7226b28f2aba059fc8c6c57e4e37bbb90a234163b2ba328be7e5a296a2"
    sha256 cellar: :any,                 arm64_big_sur:  "a65cb5d08b7b7bfa5ea73ba3c95f1495c64d72d62b7f32cd656c98272b967e5b"
    sha256 cellar: :any,                 ventura:        "be5fba63ad720d3ce9ce2152688dfdf17ddeb5f65ec59c8e21e6171386805926"
    sha256 cellar: :any,                 monterey:       "455129cffcc6bf496d506144248c0048e27791142e8066486e58d22b4794daee"
    sha256 cellar: :any,                 big_sur:        "deb6a4c66dfee9cfa5bbffdcc28ab4bdcecd977aca7fa4bbacdae4f327e7064d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e64b606d8c39bdb0d56233e5a48ce2f8f5e133d1a6d27a7dd96ca6ae516d0f3d"
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