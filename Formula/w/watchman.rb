class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghfast.top/https://github.com/facebook/watchman/archive/refs/tags/v2025.08.25.00.tar.gz"
  sha256 "a46de84ca115a094afd99943c0384bcb0aa01525e2730b7df512c93bba5cd3b6"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e773f1e3dfc7ed0b526a871f0bbd5d87a8da31bfb0a3b9e96b25d51b64ad935e"
    sha256 cellar: :any,                 arm64_sonoma:  "1d53445237b9410dc3e796f06cb590a63a46c46ad99816b19427774f08665aaa"
    sha256 cellar: :any,                 arm64_ventura: "804ac6fa4d717ca139bab29f32599cb976ce809a60cb42fd9c03fb9191e14fe6"
    sha256 cellar: :any,                 sonoma:        "83ecc78e60ca40c0ff5317f033b942276f0c0e9cf8871a3e33afda9e25b63551"
    sha256 cellar: :any,                 ventura:       "8160a1f894d26561ef3fbb13997ddd4f4b8d2ee0ee92709f08a13706c90ad881"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcc44cf66c1912f53c11c535936ea39ddc1b8b323ae02ea806211d791575d622"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4d0aa15e7d01683094e9b9c54f1290a99edf1241ad4a9c210127de403562264"
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