class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghproxy.com/https://github.com/facebook/watchman/archive/refs/tags/v2023.07.10.00.tar.gz"
  sha256 "3fc4e3a39d6c948e5ca175d1313551010282a8020a9363b50d3d1e70c76ccca8"
  license "MIT"
  revision 1
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b894f98d3db37e06827a760763ef6f937ca8f0f9e32a05db32828aa1452b76ef"
    sha256 cellar: :any,                 arm64_monterey: "161b139c34c21978f4f7a165850f81dab0ba80892a59becfef04821938e1d56c"
    sha256 cellar: :any,                 arm64_big_sur:  "add3e82dba7bc95def9e130f6611cce326bf7bdfd5f08eb08fab62a47f33d90b"
    sha256 cellar: :any,                 ventura:        "daf6e73f1f4f8c6c2728d327765b9abd68b0bf2f03d5c8a444b80dfe1860d44b"
    sha256 cellar: :any,                 monterey:       "ba7a6925009d9d6e2d7d92c044a3a1dce097912e0de32e9dc35afbca7b897a3c"
    sha256 cellar: :any,                 big_sur:        "3617cc3e39718d28c36afbeb17416f63e869e44ccc5f213537fe6daf9f0e2f1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e26c7bd488108899d597be325b734e432b76ae38af55439273840b902fc6d47"
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