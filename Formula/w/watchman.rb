class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2024.07.15.00.tar.gz"
  sha256 "a67816e22156d7d90d7421fe2b3c270e86284c8b20065b1c72a2d33d67db61a4"
  license "MIT"
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "311f5cd59f856ab8ab7804b6625613ab787a05776dbd83060e442b2f0bfddf83"
    sha256 cellar: :any,                 arm64_ventura:  "5966ff78a780723b423d92ca0581b2d76c12138d1b24987e17c70f3f083ee32c"
    sha256 cellar: :any,                 arm64_monterey: "3574aadd60bfb69a016b5550e1f69e1f995bcd84523ac0f4e3e6c1074129fa38"
    sha256 cellar: :any,                 sonoma:         "978924d03b2eb0742b4d8670b2c55a893dfd46a536e7d1914f7402c7236b329c"
    sha256 cellar: :any,                 ventura:        "e89e5983c0d66fa5e023e2242cbb6279fef25bcc8a371276b726d8e5bb13017e"
    sha256 cellar: :any,                 monterey:       "554195c7659b7ebe13b3b8b46278b7e99eb006115b08317aa93c11bba6164791"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4de6e86eb150d07bb81b6ed0c5763b6029befe3329a61d3d40975e5ef4667a7c"
  end

  # https:github.comfacebookwatchmanissues963
  pour_bottle? only_if: :default_prefix

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "googletest" => :build
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
    #
    # Use the upstream default for WATCHMAN_STATE_DIR by unsetting it.
    args = %W[
      -DENABLE_EDEN_SUPPORT=ON
      -DPython3_EXECUTABLE=#{which("python3.12")}
      -DWATCHMAN_VERSION_OVERRIDE=#{version}
      -DWATCHMAN_BUILDINFO_OVERRIDE=#{tap&.user || "Homebrew"}
      -DWATCHMAN_STATE_DIR=
    ]
    # Avoid overlinking with libsodium and mvfst
    args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    path = Pathname.new(File.join(prefix, HOMEBREW_PREFIX))
    bin.install (path"bin").children
    lib.install (path"lib").children
    rm_r(path)
  end

  test do
    assert_equal(version.to_s, shell_output("#{bin}watchman -v").chomp)
  end
end