class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghfast.top/https://github.com/facebook/watchman/archive/refs/tags/v2025.07.14.00.tar.gz"
  sha256 "d6a259c7fa97526308ddf5dcf73b3eb94a153e0b5900623cf4b2fde4b6837b66"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0c7b91de72efae76683857e008646d709d3f808e4f8dfa74046e378f8d0a5cf8"
    sha256 cellar: :any,                 arm64_sonoma:  "01869b75887807155f607288c43299a74decd7988dea285931d0795204469770"
    sha256 cellar: :any,                 arm64_ventura: "e92458980be7916f7dc774fc02015c48039174053ef306c5457e60283f56fc68"
    sha256 cellar: :any,                 sonoma:        "ae3585263201a1102b92e865324c1235447d332e500d8de8a9bf249d1dd1d1ce"
    sha256 cellar: :any,                 ventura:       "4dec624e4d1ca03fb701f55c84449879dd842a73a85f4d04907f0c1218116430"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d07de429b50ccc1024a1da5ef9ce2560f9fc0fb30219afbba87dacf06e0ecbb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40f4f8ee3e2907b0a4505a3e57258e0de3cbc3cae8312ee96731907b9ee2e889"
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