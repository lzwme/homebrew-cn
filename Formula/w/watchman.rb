class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2024.01.22.00.tar.gz"
  sha256 "04b789729c37bd7a8b69f632d8c9e2daf1ba0ba2a28169f208a8a2ec3125cd4a"
  license "MIT"
  revision 1
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "2a0c5f2a82676b4a47b7031e4596373d98301bb2c68d4edc52160eae3e7020dd"
    sha256 cellar: :any,                 arm64_ventura:  "d54f8347ce9cf3cf8b59f892f8c7e1eeed93540b9258039eb2e5c1e8a757f047"
    sha256 cellar: :any,                 arm64_monterey: "5f65199bdcc32ccc0b228ccb9af4dd46aec22da901d2a5b8f95c0830fbd2081a"
    sha256 cellar: :any,                 sonoma:         "c481ad976a58c3ca35975c03c2f0ee8a4059bcb9532d4b91555c5e6ca7a37ee3"
    sha256 cellar: :any,                 ventura:        "a38d58da2fd1b62cd5b105197c36aa184a3693f8787d9969f3bf3e9e46a29939"
    sha256 cellar: :any,                 monterey:       "6dc7cdff5b7b20bad8788b4478cc9548d6f671044965f909bdfaf7b4c0ae11b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cce90ccfe61b5d1bc8a3a762e9e2a16a4f25b043088a3d60497d6aec09b787e"
  end

  # https:github.comfacebookwatchmanissues963
  pour_bottle? only_if: :default_prefix

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "fbthrift" => :build
  depends_on "googletest" => :build
  depends_on "mvfst" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
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
  depends_on "python@3.12"

  fails_with gcc: "5"

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace "CMakeLists.txt",
              gtest_discover_tests\((.*)\),
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"

    # NOTE: Setting `BUILD_SHARED_LIBS=ON` will generate DSOs for Eden libraries.
    #       These libraries are not part of any install targets and have the wrong
    #       RPATHs configured, so will need to be installed and relocated manually
    #       if they are built as shared libraries. They're not used by any other
    #       formulae, so let's link them statically instead. This is done by default.
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_EDEN_SUPPORT=ON",
                    "-DPython3_EXECUTABLE=#{which("python3.12")}",
                    "-DWATCHMAN_VERSION_OVERRIDE=#{version}",
                    "-DWATCHMAN_BUILDINFO_OVERRIDE=#{tap.user}",
                    "-DWATCHMAN_STATE_DIR=#{var}runwatchman",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    path = Pathname.new(File.join(prefix, HOMEBREW_PREFIX))
    bin.install (path"bin").children
    lib.install (path"lib").children
    path.rmtree
  end

  def post_install
    (var"runwatchman").mkpath
    chmod 042777, var"runwatchman"
  end

  test do
    assert_equal(version.to_s, shell_output("#{bin}watchman -v").chomp)
  end
end