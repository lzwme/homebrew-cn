class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2024.10.28.00.tar.gz"
  sha256 "a34c511ad9d2713328371f1aa663ba98ef5acdd934ce13ef6336da3548f855a5"
  license "MIT"
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "26e26ba0f1ef66ee72c7bd4ed4969a0d72c907b000d14a769990c2a147f37e00"
    sha256 cellar: :any,                 arm64_sonoma:  "5dcc1650ad14af2f02304ffb0823cf96f9bd32dc5d3aa39962b041c36eb4be43"
    sha256 cellar: :any,                 arm64_ventura: "d418bdf6c0453fd2599cd92641107d4d8ca98cb75914f14f56d82fc202457fa6"
    sha256 cellar: :any,                 sonoma:        "97bce127ce7dd9401e8f5226eb1c2464f9831a788af43dc1ded9cf327f6adfc2"
    sha256 cellar: :any,                 ventura:       "c9a3f9bcdf91e4e609b8da5987f67a27169a260de6181bd1696206b79182c7aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "439a614bcbb6daff1b45fd92855ef114a0526e0d11864ca41c45222988d77752"
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