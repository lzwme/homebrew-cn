class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghfast.top/https://github.com/facebook/watchman/archive/refs/tags/v2026.04.27.00.tar.gz"
  sha256 "9bcdf6118ef2280e63896e6c6bd9a8c53b3c0a26bae4a0836d886735be0057f3"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6ddd6465ba76fa8934ed166985eacfa13dbfa2e0fc50d7b342e72cb2cde5d2a7"
    sha256 cellar: :any,                 arm64_sequoia: "9b19d4704c33c567ca1b0caf66b727930a67e80f5f488266a261ea6399b0096b"
    sha256 cellar: :any,                 arm64_sonoma:  "beb3f4701123171f0b4fd5f62feb54b3001e980bebb15ff8508878554cef21a1"
    sha256 cellar: :any,                 sonoma:        "f9e0f0c05751e1c8a5383895755b2470bcdd5400f9bdc99b93efd1d13fad97cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2239a97211c1967d07ade3100f2ed532f21f729dc78962a4961ae2a2d54738c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0138a987f6ec8c76e6f0dbf72e52c157f13e51bd1c05b5210245f783dc5c324e"
  end

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "gflags" => :build
  depends_on "googletest" => :build
  depends_on "libevent" => :build
  depends_on "mvfst" => :build
  depends_on "openssl@4" => :build
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
    depends_on "openssl@4"
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