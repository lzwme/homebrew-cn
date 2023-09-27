class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghproxy.com/https://github.com/facebook/watchman/archive/refs/tags/v2023.09.25.00.tar.gz"
  sha256 "ce0f2386e2dc316bfe11194523e3c51c3759af5d7fe7c9ba8a46e0c446ce7b00"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f8bc19df79ceeb3427dfea54cc0f340ca620b8ea3862498b54261232a3fb72e0"
    sha256 cellar: :any,                 arm64_ventura:  "ea5cd3fe5c523f3054ea103c6ace26aaa1d91933537118193756cd3c34cb9bcb"
    sha256 cellar: :any,                 arm64_monterey: "40034a4d9ad5d85f2e79ebbde8918f90f538f7b45c5864cb08a3fc006f847760"
    sha256 cellar: :any,                 sonoma:         "c5e0082c0307b83711109e81c08e43bed38a3ae9ee6c3b89ad0c07b9acd7c110"
    sha256 cellar: :any,                 ventura:        "782088fe5414d9f5fec9b097d22f6ac8982eb74be6025cf8ae96d657456dde39"
    sha256 cellar: :any,                 monterey:       "b6a50e76fd35c5de3e1f4c50d7f57791bd2e84f63cfeb312e32897fdcf76cffc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c00d52381455a1d330f994844ce00cbfdb8d0150a01f75668988f5d194627ba1"
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