class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2025.03.10.00.tar.gz"
  sha256 "047dbe45720f4eec3b8f30de4c3ae07dda7ef1f7e67336ca98490656319c00d3"
  license "MIT"
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "539cd8e9a98cc2a0ad9302782d9df5d6481701b09555667d0581f2b91f3e0df8"
    sha256 cellar: :any,                 arm64_sonoma:  "3a509de4f527b2335645ee195d2b09d7ab64d0630db41d4f651903134e2072b5"
    sha256 cellar: :any,                 arm64_ventura: "db4f41d9e265aa57cf432ce574d7d17f02c42705d1e71d761d25de6eca5bed84"
    sha256 cellar: :any,                 sonoma:        "98308a1dbcd0f9a41fdd468f96b10c3429116ceca2aba2e5ecb8636844974584"
    sha256 cellar: :any,                 ventura:       "03cef545398ae45b8759a7a11065ce018fbac1b5fe7b28dc2df3bf57cd556420"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b7c4c2f9e57a4fdd362d227a72dac2d109310b7911a99d1da2ac6e65ad6d9cf"
  end

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "googletest" => :build
  depends_on "mvfst" => :build
  depends_on "pkgconf" => :build
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