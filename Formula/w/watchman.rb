class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghfast.top/https://github.com/facebook/watchman/archive/refs/tags/v2025.08.04.00.tar.gz"
  sha256 "8029db629fb386b13e58fdae0657b8f5a8b545bb42d4efd0c3c78a5aaee875ee"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "417268d812084d5b2ca35ec7968ed3c9a41a26c781bee2f9e170322f11fa5c7e"
    sha256 cellar: :any,                 arm64_sonoma:  "67607b7a8df1763dbe4b040db77c6c4da27ab5d6ee23896642a10bf2594d1712"
    sha256 cellar: :any,                 arm64_ventura: "4c06bb1e8cd3b03fa47b029fc0fe9096de12d15d4ba717fad2b71f29880690e7"
    sha256 cellar: :any,                 sonoma:        "d0c9dd295b19326c0951b30a3226d98de11cbbd68765512f410aa241471637ae"
    sha256 cellar: :any,                 ventura:       "7446dbedb3e93949a331d231fdb8dc0c0a6c44c6ba5a3522fb976a508b86c9e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0186f626a26b3c1e666d42af456237fe598cf13b4afbaeaa7fb23c8595428f28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea282154003cb8f7b29eecb077cc2e2fb63b238ec0a8ee55cdc616f514ad68ca"
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
    bin.install (path/"bin").children
    lib.install (path/"lib").children
    rm_r(path)

    rewrite_shebang detected_python_shebang, *bin.children
  end

  test do
    assert_equal(version.to_s, shell_output("#{bin}/watchman -v").chomp)
  end
end