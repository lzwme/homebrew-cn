class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2025.02.17.00.tar.gz"
  sha256 "f6752776f04e40cd734132ef099a0235d32fbf73259ea7356625a1bbbe83cf6f"
  license "MIT"
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b523d904af54ba532d4f37d243480c64b49900e3b647704e2a180971d13e3835"
    sha256 cellar: :any,                 arm64_sonoma:  "54936adb1ffd25b9c2cc7800e1158150def0648f1c81159e1c9b1a3b35390f66"
    sha256 cellar: :any,                 arm64_ventura: "e4e09082c466d324c5a1846bc9f0dca1856d8e1fb9f1c134a758a74899cc51e0"
    sha256 cellar: :any,                 sonoma:        "92d06cb788fdf2df445f1dae3721ab7fec769b2c011a56fd8dc37f3702f232c9"
    sha256 cellar: :any,                 ventura:       "8b7646c22d7b4c42cfd82a7b952f539ca8ac0fcf0b69deaea6e4cf594bd23e98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acdd14a234faf2235cf31f8fa00914eaf00a8ed9796d8c64a26caf62e0619c7a"
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