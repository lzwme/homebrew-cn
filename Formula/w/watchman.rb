class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2024.11.04.00.tar.gz"
  sha256 "bc41c548930aed09e622c3d2427ce76201a12739273895658eae25b0dffa884d"
  license "MIT"
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8dd6bb88326293addc6215892a5d6fc2efe570e9ed43ca954db36c82cc845eaf"
    sha256 cellar: :any,                 arm64_sonoma:  "ca46832d5cd6469799a816e274a79e187f1d01e25cadb59e6e466fcc79a39a80"
    sha256 cellar: :any,                 arm64_ventura: "a0c51c2cf63c2fed00e1b6349ec91e2cdb9c1a49d9cfc059b78fef6a47883136"
    sha256 cellar: :any,                 sonoma:        "384e1069c9459ee879d65626feb80fbe80df9709cee6d9b087522fab0bd07550"
    sha256 cellar: :any,                 ventura:       "f2b2efe795d475c833bc9cb9a599ae192c0d95a95cb1b6da109dc34ed300e931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd869e12200dfa81e6d32534edd62400e8193bc3c5e50a456b6a8a4f16474070"
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