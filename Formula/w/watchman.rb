class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2024.07.29.00.tar.gz"
  sha256 "5a48648e5ba85120053228ac0fe0d4d34e78711f3c3fb97177641c4c2d6879bc"
  license "MIT"
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1160244b2dc5c10f574d895af01e60890b57489176d0705ec0df1df3b17b8d76"
    sha256 cellar: :any,                 arm64_ventura:  "89c01b5458eebabb7f9856289675d7bf5db3ff9a788a4990d2f4898bab8068c7"
    sha256 cellar: :any,                 arm64_monterey: "bc0b3eded815938a0607d148b07c36bb8241fdce904dfb1f7ed24454d5933b9f"
    sha256 cellar: :any,                 sonoma:         "23f54986933263b8e481c1dce80d12cb72c5447bd13b5d42b5649208768e762e"
    sha256 cellar: :any,                 ventura:        "15dde01f63de3bed5be5ea32a382f81c5a1dd108c90b33c9f49f8db17e23229e"
    sha256 cellar: :any,                 monterey:       "40b4c9ad69cf8f85050c64232c4ce6d3471108b0fcd662fb223bb471f0c85d0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcd251c4ae6fcd70d493b7632a64c051a0f1b5d0326bc6d11a0d37932b4a73ff"
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