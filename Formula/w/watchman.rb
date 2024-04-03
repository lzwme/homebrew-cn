class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2024.04.01.00.tar.gz"
  sha256 "731b5efc83b5f619f893f04c7b793caa6fcd2e7f38cf9cc4cee6a7d1df5f5007"
  license "MIT"
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4f35a514c25827b41558c032ecb25d81ef311a57074fc05f3e2a4f7a5ef76b61"
    sha256 cellar: :any,                 arm64_ventura:  "bc6522faf1aedbc7403d6b088e3833fd440b8aeb4c96d7e9a0beca93683b59d3"
    sha256 cellar: :any,                 arm64_monterey: "c7185b7ccf91f6d9e3ad6b27b5b65a84de52d820a8c43d4ce066424b5ebe3401"
    sha256 cellar: :any,                 sonoma:         "10ad500e65390f49b8d0e6339ab969038b5e54300d660410e6a50c1dd25e5490"
    sha256 cellar: :any,                 ventura:        "af100309ba4278ae7f2806d78a413348bc072df050680c31c274ab6ece056c1a"
    sha256 cellar: :any,                 monterey:       "97dbca7898d6957bdf951facb2a56a9e629befdc142ef28e8eee85b6258d0dab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "747d72347d8638c740efa54eddb3ac574f0c23a0610a88bf90cf282ddf91fe8b"
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