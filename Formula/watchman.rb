class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghproxy.com/https://github.com/facebook/watchman/archive/refs/tags/v2023.06.12.00.tar.gz"
  sha256 "a57e8f0b4bbeac51e151e23911916d1eb1f47cef91bff578df66fc5484411613"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ddff3e299add4e0a011fbca070eeea062dba7511e3b37a0d26b39615e48df76b"
    sha256 cellar: :any,                 arm64_monterey: "fb9616c25558e0bd0e18f33bb26d57ac68d8318cfde06b24887b7f0bedd1c7cc"
    sha256 cellar: :any,                 arm64_big_sur:  "badb6ad1223e3544335cbbadb75304368666de0f09c0e85ac016581fac5a71f9"
    sha256 cellar: :any,                 ventura:        "3d13dee59c109a0b8336b5f071f140534c902c74482281bdd7121c7fc4c70b7c"
    sha256 cellar: :any,                 monterey:       "23d1c4c1d18626bd9c0bad8e4fe99cadd7b4c42b2c8aa8e89a8c8e00f24afe56"
    sha256 cellar: :any,                 big_sur:        "303cd1553787a25eac5b856a41525d509e0ba0314ef28a37e888bce89e469f83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4862365ef0cc8a045fa4cf56b08d3a78448885cd59baef3b1748401a85c0ac8b"
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