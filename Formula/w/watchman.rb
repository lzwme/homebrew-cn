class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghfast.top/https://github.com/facebook/watchman/archive/refs/tags/v2025.12.15.00.tar.gz"
  sha256 "b26fb42355f32b14b5c3c2d7cca72feee7ee2dd79a27026386c48f28d51b6c29"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dab1c55a43b0bae6ea211e713689c99d2e2f9bdee350d43b81fa7f59fb6fe83c"
    sha256 cellar: :any,                 arm64_sequoia: "cbeeed7b55a59516fd04accbe9213fb8ae460fe2e57539e131ad46dc9da12f72"
    sha256 cellar: :any,                 arm64_sonoma:  "ddcd03c7d172ef084224feed64a8476b9d2f0b35719627a13f943d01e00b1895"
    sha256 cellar: :any,                 sonoma:        "92fc27cae98e3409c3a4b6e9143b5641be1973d91d38ff3d00bf3dde73a90413"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed1b5d48baa7db8104ab8de685178374beb7ce34c93c89a70fbc1a0a0602722f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c240fcb4090ed90d9d48e0415e0e62c436a82b42c3b87713bfecf82a61b73753"
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