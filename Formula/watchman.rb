class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghproxy.com/https://github.com/facebook/watchman/archive/refs/tags/v2023.07.10.00.tar.gz"
  sha256 "3fc4e3a39d6c948e5ca175d1313551010282a8020a9363b50d3d1e70c76ccca8"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d237530efa59d0339b629ab5d25d4690e2678cfda078dd685f3e73bfceedc417"
    sha256 cellar: :any,                 arm64_monterey: "efe9f91c15e8f1ccacd246b953e5d9ee9d355375b64d75a8cb90fc3c4e3b163b"
    sha256 cellar: :any,                 arm64_big_sur:  "dec40215da4dd2f7e7432a14fb8ac13bca9a2a6a2b085a2a3a8e25d1140ddc1d"
    sha256 cellar: :any,                 ventura:        "13290215e856883c8524fd1235a559c9cf198dd841a53d70ae1ccffcb6b4c697"
    sha256 cellar: :any,                 monterey:       "2e679ac327976c603bebc72b85cebf8ebbeaa264583dda9f732d078b3af79e72"
    sha256 cellar: :any,                 big_sur:        "e6f027c64e378902a0bcd4b91210ae6b4134e476fe1861ccf93fd9556f998ab5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "193d0770f55ec457759372177a88046567813a4b627dac85b8a29b0116667a42"
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