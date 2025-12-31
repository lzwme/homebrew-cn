class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghfast.top/https://github.com/facebook/watchman/archive/refs/tags/v2025.12.29.00.tar.gz"
  sha256 "21ad73b52223d91575e9208831401bfafc2b8aad103292e942d193e0a4120f71"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3ac82160f674aee940dfc7ab8e3c57e77e443996150cfeb9e0739fd59803ffd7"
    sha256 cellar: :any,                 arm64_sequoia: "4a27b23af063e917912058a8a8c9ca1d2340b54567f18b025a4974efbc6d34d1"
    sha256 cellar: :any,                 arm64_sonoma:  "920dbe9d15ee69743f26baabb7207b0826997b60dff7e8d1f61637a555c43a30"
    sha256 cellar: :any,                 sonoma:        "6b17d528bbcc224a547d676cab3a09fbed7da583a534be445e8958da58110408"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88c81ba30a85bb82f3b2235fcc6dd511e87cf9f4c74817a1908ab58958543126"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41741cad7da065b7e69f64cc1f47c79e63cf48dc9cf630eb5577a5ba403d1788"
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