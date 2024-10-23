class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2024.10.21.00.tar.gz"
  sha256 "bda7f7af7bfc6154c784f0a69fcf3a9f1b4ecee0b3e0fcbd698443e5b14ad15e"
  license "MIT"
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3b336afe25d8c3f68f2045f798cd29f5a1c9728f93c7a59f5b02d4cdff120e8c"
    sha256 cellar: :any,                 arm64_sonoma:  "eec40c96f567befbe68fb3365a110a2aeb78c4d9bd696c2240eb8d13c7e8fcf6"
    sha256 cellar: :any,                 arm64_ventura: "bb52e8f360e16859e2316552985ca3fe0acb6481ac0cbb60e2634642b763cbbe"
    sha256 cellar: :any,                 sonoma:        "43fedfdca91819883df8d53eae814dd781bc03c46359b8b3b727e2e1089b4d16"
    sha256 cellar: :any,                 ventura:       "2f622d3fdf4c2d59e45dd3d3f5aacb28d0652752e1c1d7eb8682db017ef3bb6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cae5974af06024a90931d43aced9628bae75da0e2320e0065c46a72a5da8270f"
  end

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "googletest" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "rust" => :build
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
  depends_on "python@3.13"

  on_linux do
    depends_on "boost"
    depends_on "libunwind"
  end

  fails_with gcc: "5"

  def install
    # NOTE: Setting `BUILD_SHARED_LIBS=ON` will generate DSOs for Eden libraries.
    #       These libraries are not part of any install targets and have the wrong
    #       RPATHs configured, so will need to be installed and relocated manually
    #       if they are built as shared libraries. They're not used by any other
    #       formulae, so let's link them statically instead. This is done by default.
    #
    # Use the upstream default for WATCHMAN_STATE_DIR by unsetting it.
    args = %W[
      -DENABLE_EDEN_SUPPORT=ON
      -DPython3_EXECUTABLE=#{which("python3.13")}
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