class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghproxy.com/https://github.com/facebook/watchman/archive/refs/tags/v2023.11.13.00.tar.gz"
  sha256 "6851904765ba98323974d93904fb5ca676337c705d667aac2e41af846bd0f4ac"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d3ccabd397fce4933622f1ecab18a3d792aa7deb41bcfad7673fd79117907268"
    sha256 cellar: :any,                 arm64_ventura:  "63d7467aef34b53b0fd428d3998a495eaba56e148433205f93ae5b341549c567"
    sha256 cellar: :any,                 arm64_monterey: "66add6e28e12cca52b4f9e7e272fab19fc09373ef8eed22628a5e88340df308e"
    sha256 cellar: :any,                 sonoma:         "45b42fbf133e83631324f16e52f13ea1fcb60c83a2e40e4618e1e40d6f5aca22"
    sha256 cellar: :any,                 ventura:        "202fc6b0e65969d52d7f7065d72a78916509e401515b279b58dc6f6ce5abb552"
    sha256 cellar: :any,                 monterey:       "d3e328e5a38bb3c816ed0d2abbff33f4e05db945c5969eca5e700aea1904f4ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b00b19232485688379cc280d25a5bb0dd952e0eaf0677a13322425d18fa2bc50"
  end

  # https://github.com/facebook/watchman/issues/963
  pour_bottle? only_if: :default_prefix

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "fbthrift" => :build
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
  depends_on "libsodium"
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