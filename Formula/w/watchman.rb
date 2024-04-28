class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2024.04.22.00.tar.gz"
  sha256 "e9861178f959d7913648e9b5d45cf3072f96f91d16064bba527c4893df807cce"
  license "MIT"
  revision 1
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "82958dacc4e86f3d6db78d9d1928abb28a70e85a7a1debf972289701debbd68a"
    sha256 cellar: :any,                 arm64_ventura:  "69d23293ff1764cbe753dbb5fd1ceb4121ee781f1d2f5dbfd0098e8a4ee67f2d"
    sha256 cellar: :any,                 arm64_monterey: "6350dc5e23e602de52e6fc0db1e3e15d526d2ce96fb2a4c3a74ec0b079c3e709"
    sha256 cellar: :any,                 sonoma:         "5c965aa94c0db36bf80e92d0a90f11db4e87713f6fd4f2a8156e2ef66e2fe6ef"
    sha256 cellar: :any,                 ventura:        "2e28c0bbf25df8ab8195d29ea5224b0f45c6c2d0cc3e3d30f49063981a982681"
    sha256 cellar: :any,                 monterey:       "9d5c8ef2dfa95e55a6a19f7edca74816b2e1ccd5ec459767a0c747d4af6f20a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3c69f8adc9775a0e2f22d9878633ac2d68577dbd221652ede0f961324e7ca8c"
  end

  # https:github.comfacebookwatchmanissues963
  pour_bottle? only_if: :default_prefix

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "googletest" => :build
  depends_on "mvfst" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "edencommon"
  depends_on "fb303"
  depends_on "fbthrift"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.12"

  on_linux do
    depends_on "libunwind"
  end

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