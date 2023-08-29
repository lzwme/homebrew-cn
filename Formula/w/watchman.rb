class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghproxy.com/https://github.com/facebook/watchman/archive/refs/tags/v2023.08.28.00.tar.gz"
  sha256 "db4945fbd47a73ce7e24f348b69a276405385c7128d5c60035bea871c4246660"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4948f79bf20a781c35dc4dd8cfecf0e4a376de219fc22af696bd20e1478d105"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28369e93fbec7c746c0aaa2bf8260323abb6000a47495be7797848e820f1e956"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8c1d77b413813b56fca62ea2db5ff00a8523b4e86aa61de3706cdc2b251cd10"
    sha256 cellar: :any_skip_relocation, ventura:        "6da555f8cc8dbf80823e10ffa3f33a13c0cfa8e5791a90f60c4a62a23e5daf26"
    sha256 cellar: :any_skip_relocation, monterey:       "f9ca563807a6726e35798ea21a86d055eb72b9de529102e30cd1342ec275c7ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "872d38c1f157f02b98d67406310401233552cea55332d05fdd6cf7d3ca8fe8cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1920aa8110dd6c7bdab13f26a1dd25886a6bc242c2271e3bae0e55e4b9a46ca5"
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