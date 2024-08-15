class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2024.08.12.00.tar.gz"
  sha256 "e112c5369accd608d351779342cd44bb8f009729d64f0120dba2057b262ed64c"
  license "MIT"
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "090b882ddfac10b8428a3d6d2ab3fe6ced63ecb7eb5ff70eee6010d1b4c3db13"
    sha256 cellar: :any,                 arm64_ventura:  "7ce7cfde1885857931866c7917ee95b91c5ed7f8763ac5e2c9a45a22cfcb6cf7"
    sha256 cellar: :any,                 arm64_monterey: "9b94ea28bf27baa88e9924d515a2143a01165635d01a714cc3277c36ad47b060"
    sha256 cellar: :any,                 sonoma:         "2c5ff78ba4d28519071ea5bf511f52e71f3bcdfc70c7630296da1e97a304ec76"
    sha256 cellar: :any,                 ventura:        "dd4b4233721904df612b2017f88027ab1c08aeb50018570014b2a3f0c1717ad7"
    sha256 cellar: :any,                 monterey:       "0e589379121d48fcce615951da0be0eefc393f6fc1b4fce32de8f0f51509ec98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6616d07f5a7b2622b3402dacb8eefae4f02d051abad56dbd292c36e8e8b4a7c5"
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
  depends_on "python@3.12"

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