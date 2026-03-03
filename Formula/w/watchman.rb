class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghfast.top/https://github.com/facebook/watchman/archive/refs/tags/v2026.03.02.00.tar.gz"
  sha256 "c82c42560536d680e81ab25bdbb70a5595521d6086bfed3f39400ffcbd367e2b"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ec8a2dd52845100f9c8d15d9942294375cac95e83e43f38cc9c9ed47e0a90a49"
    sha256 cellar: :any,                 arm64_sequoia: "c688d15023ab5f2fc4a599560daa606bf0bb98c84c4e18df0e2d1fe10c8844fc"
    sha256 cellar: :any,                 arm64_sonoma:  "e6f083191e6c6644565ccb4db48f0e58ad04b2446293ab2da17af31cc1c4523d"
    sha256 cellar: :any,                 sonoma:        "e31d19c0d1718ce4ee733bc4ad6b3edf3ced67d99d7c85bbd7d5128019536f44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f62db5fc5843644804d57ba358f6aa995e5e72deacfd5f10c52332c73285d99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9824591d370c4bdbedc3b2982045b37a0a92a964b05b4c329b9eaee36140a0b6"
  end

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "gflags" => :build
  depends_on "googletest" => :build
  depends_on "libevent" => :build
  depends_on "mvfst" => :build
  depends_on "openssl@3" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "rust" => :build
  depends_on "edencommon"
  depends_on "fb303"
  depends_on "fbthrift"
  depends_on "fmt"
  depends_on "folly"
  depends_on "glog"
  depends_on "pcre2"
  depends_on "python@3.14"

  on_linux do
    depends_on "boost"
    depends_on "libunwind"
    depends_on "openssl@3"
  end

  def install
    # NOTE: Setting `BUILD_SHARED_LIBS=ON` will generate DSOs for Eden libraries.
    #       These libraries are not part of any install targets and have the wrong
    #       RPATHs configured, so will need to be installed and relocated manually
    #       if they are built as shared libraries. They're not used by any other
    #       formulae, so let's link them statically instead. This is done by default.
    args = %W[
      -DENABLE_EDEN_SUPPORT=ON
      -DPython3_EXECUTABLE=#{which("python3.14")}
      -DWATCHMAN_VERSION_OVERRIDE=#{version}
      -DWATCHMAN_BUILDINFO_OVERRIDE=#{tap&.user || "Homebrew"}
      -DWATCHMAN_USE_XDG_STATE_HOME=ON
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