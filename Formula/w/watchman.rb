class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghfast.top/https://github.com/facebook/watchman/archive/refs/tags/v2025.07.21.00.tar.gz"
  sha256 "41b2513b3f14d908abe8bf8e5c877c30a95f32f1708481f4f33f52e9fbd1432b"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bdebd67673746f1fa0d46f8c657eda375eaa75cafc77e82bfb12eefd82eaa9a8"
    sha256 cellar: :any,                 arm64_sonoma:  "73e40959454f203a3a713b01188f1b386fe4d03c5fe1f9de89ff6f008a138c65"
    sha256 cellar: :any,                 arm64_ventura: "ae5fc64e556525c01f7828767fa75db73c039a18041b375365eeca286b8157b0"
    sha256 cellar: :any,                 sonoma:        "52205ccfddbfb242c900d98db2b3c35fd1ac515fadac11a01d252fa6d2fc0942"
    sha256 cellar: :any,                 ventura:       "c5ab5e6c79145c15a249b95522d969b662e1586f807308128c1a7c1d1cb3132e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c11db53a288de14103ba9db0579646662a5978d7bd5e9c3cc432d74752fa7dc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9846712287e60dd4f4355ac07097f5590aa9340fb676c1baf1dc893c251035ad"
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