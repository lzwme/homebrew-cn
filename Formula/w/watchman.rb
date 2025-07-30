class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghfast.top/https://github.com/facebook/watchman/archive/refs/tags/v2025.07.28.00.tar.gz"
  sha256 "1164189736ef217913f26cfd9d2fc99a6d764854dfb79d710387891c11d79a12"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "245e83a20466f095102240c57c8a78eee00b3d8492ad22cd2f3e9239518d14ce"
    sha256 cellar: :any,                 arm64_sonoma:  "80fa480011776c27660706f78acb1c7aa9c353999acf936d12ef6d8946aeb263"
    sha256 cellar: :any,                 arm64_ventura: "31411268e2d30cb1015f7f3d693053b820a20ee2f602d8f7e5ac3a8eb8c79de3"
    sha256 cellar: :any,                 sonoma:        "5ebd2bc0bc15d732ab93c26a82bb23bf480d20bca2d3e90707b863cf9b162184"
    sha256 cellar: :any,                 ventura:       "5bce9a4982767ae6b66db20187dde87512e246ae56c18c10062601284a2c1ce6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dff22d83c01ad4c1b1e882d23652665acd07aeede6e700a406c44c0efbc8b861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96b445f327cde949cef333173879b65669a9ed1e1d571137284ca2bb1f5de838"
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