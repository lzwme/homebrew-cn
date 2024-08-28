class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2024.08.19.00.tar.gz"
  sha256 "ba6bdb8c565ac72036ec4eed940d3907c9138c7c329bf6035bfbc0202c335008"
  license "MIT"
  revision 1
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2527e7d41885040537d0ba4d04606afa392cf58e34fa03e9c8d994daa85e3162"
    sha256 cellar: :any,                 arm64_ventura:  "d9c049f73ec53e29dbbd3f59dd42038246c0a2e52aa9e063ae775ee820cff84f"
    sha256 cellar: :any,                 arm64_monterey: "eb809e3b90c6eac08f9278849d2fd7233858c70fd5a1dac4772ec51e3e9ad974"
    sha256 cellar: :any,                 sonoma:         "8aab661575fa07b6d2d4104380820326c0e10cf9893a71b7579b3357a667f1f9"
    sha256 cellar: :any,                 ventura:        "70b9bd13e5a9f0480dc0f7f9715d789bffd6372dc3f48a47b85f29440820f1b0"
    sha256 cellar: :any,                 monterey:       "abb4695f6c294932f32d2c390c75516a5375a776a56efbe373c3ef4398d11262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbd6d15e56600602f6cd1a658b92f8f1785457259c73bb901a5bb18bee30d8e2"
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