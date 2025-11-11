class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghfast.top/https://github.com/facebook/watchman/archive/refs/tags/v2025.11.10.00.tar.gz"
  sha256 "b40fcd0daa648baa704baf3b0aa4e998ba3b2ff4f109f9b89ec0afe48f6aa06b"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "704cb72c432146daadb1e7d3603cd2b08b1d6c074a1b116d8f56cb90b25c5e9a"
    sha256 cellar: :any,                 arm64_sequoia: "f93d6cd64c26aefc78a0b4e0203ec33b7c564316da0cc19d3d6bec81b0232aec"
    sha256 cellar: :any,                 arm64_sonoma:  "1ca41c86f33a49f5c2cf508f94b21de99714b7c65880d3b062e76c51c2c4a859"
    sha256 cellar: :any,                 sonoma:        "ace9db8c26f57ae155b523802ef9bbcbcbf684d9acdb1148d8cea67d7da48362"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4efe98c45c1801cf33fd80fed2cb6883138e77fc0b21439d13950fe72e7bf15d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33932b33ccbe715d8ecd2dd8b5feeb20344439793e6cb6b187846f1070fcc73f"
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
  depends_on "python@3.14"

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
      -DPython3_EXECUTABLE=#{which("python3.14")}
      -DWATCHMAN_VERSION_OVERRIDE=#{version}
      -DWATCHMAN_BUILDINFO_OVERRIDE=#{tap&.user || "Homebrew"}
      -DWATCHMAN_STATE_DIR=
      -DCMAKE_CXX_STANDARD=20
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