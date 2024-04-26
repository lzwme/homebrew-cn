class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2024.04.22.00.tar.gz"
  sha256 "e9861178f959d7913648e9b5d45cf3072f96f91d16064bba527c4893df807cce"
  license "MIT"
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4bdec8f19ef2844f61b5656192fafdea8ff5a0e33325f37ef7046a2f717ad887"
    sha256 cellar: :any,                 arm64_ventura:  "0d6b8bdf6c1b67311aae3407f419a644870b5c320f5842eb4022ec735d8b2059"
    sha256 cellar: :any,                 arm64_monterey: "f7cb3b39cc50ffddeac49331e33ac1f69829947797a7afc4da866f15a646388e"
    sha256 cellar: :any,                 sonoma:         "f4a5fce7da65d062b01e9d23807895c455f4667ebcb1c90230be31212a4aacf6"
    sha256 cellar: :any,                 ventura:        "2e77f24c7a32a7bfa92fce011b8c23c05c6df6f47a81cd0040931478c1e161b5"
    sha256 cellar: :any,                 monterey:       "7adb8238cf79a4ac2af045c8b537bc93cf7896f7a4734685e4f5157c18681b5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7565fed69e036dfe9f59a899cffdc677a768cef12300fd0658b0db9a642a1244"
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