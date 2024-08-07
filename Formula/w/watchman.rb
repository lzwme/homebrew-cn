class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2024.08.05.00.tar.gz"
  sha256 "e70e1049b30cdfcdaa510a66399b8fe20fa2303a73271ba22c2fecfca4c3d01d"
  license "MIT"
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6ee1609b088b69eb8d797db868794298a6c798659b5381c9fcf84e0afb581755"
    sha256 cellar: :any,                 arm64_ventura:  "5f7591ae839f24e59739ada15c9f19a19a11efaa93a53c05c1a73423f81ebf0d"
    sha256 cellar: :any,                 arm64_monterey: "aa048b281e45cdd5c7f1a80efe93ed29137022c3de01fc581e5d9baf74150f63"
    sha256 cellar: :any,                 sonoma:         "06dec7249450a5e76cbf920f39f1cdebc7b28afc77ef9810664beb12fe8860fc"
    sha256 cellar: :any,                 ventura:        "232ea673bd2ed508c54f7a42a28b9fb48b9108e0ebf0c5288a22e41261cabbec"
    sha256 cellar: :any,                 monterey:       "891acd08b199c3942d11c4403c9289f60622387354681d3b6c69376eb616e6a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17394e1f11257b5c1406f8c65a0dab1be99e7342b062c14e43f25261700452e1"
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