class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghfast.top/https://github.com/facebook/watchman/archive/refs/tags/v2025.12.22.00.tar.gz"
  sha256 "59273a2d71f9ebae5104ad4c83d1cbf07e5e2ce2527134a948348f1a92077c4d"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f53ef4dee87995b8570b1ed591a282059b3edcc424f9e467f248b4b7c4900284"
    sha256 cellar: :any,                 arm64_sequoia: "81869740ffc095d6336ac01e8809d96dcb53189d821212d9a4966f86370e8c5b"
    sha256 cellar: :any,                 arm64_sonoma:  "730f0a68e0122ddf8064a64bb9830b9514446e5a22b50bd7eabf6599c4d29875"
    sha256 cellar: :any,                 sonoma:        "08d8f68eee3d6226f132645e7eb116bc5b2c134f10541bca12c9dfdf4b631ef0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c53a51e15a4ed0c66c9ff149d4a7e2db84493f5f263b1a855fd60bef15fdded0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0545c7917ad4b697342e6a62edfaeefe078daf87b505fdffc73db07ca29746c1"
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