class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2024.09.09.00.tar.gz"
  sha256 "1013e0dcc22d70fabe35ba30928b00d815f88b97f90d51f310f1982f8fbac28c"
  license "MIT"
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3cf06b71825dc4dd3030201a6760466f593da3e5e74d9b334b7a380daa979866"
    sha256 cellar: :any,                 arm64_ventura:  "73cec64603b6f6bc0a610d05261114f77f4940a4bca9dd8f3b46fedaaa11fa64"
    sha256 cellar: :any,                 arm64_monterey: "716fb2194ee73d51dc3faa23202745062f31ed4599abab83bd4ded26d2b2b7cf"
    sha256 cellar: :any,                 sonoma:         "0a8029884e5f1c5366367bcf1a2ced06027ff7415840b2ac3d8531a6f67140d1"
    sha256 cellar: :any,                 ventura:        "6b402f47fd9494a66d15fb1c3a1caf97e2698e770b2126f0b4ecb0e294e784b1"
    sha256 cellar: :any,                 monterey:       "6d650d8c4e43ec47cf9447a7492f38900909650a8c36978b362bcd5a1fbb8866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fd1f956331093dc2e89c5684c6aac3845291cee8d6e0e80ddfb8cdebbb3a920"
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