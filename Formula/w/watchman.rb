class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghfast.top/https://github.com/facebook/watchman/archive/refs/tags/v2025.10.06.00.tar.gz"
  sha256 "f89ee74c9ffbb3de3dfaa07d9696c21dee17b10a87bace44155c729477729dbe"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "6bd4a030a9373d844b15a8a83e1cdf5c3af9d7e0784c12525349662a2d2030ee"
    sha256 cellar: :any,                 arm64_sequoia: "75cda70f404ac4a0a78795b195a0b15693b99ec3f612fe3503e9ad2bdbc9d5c9"
    sha256 cellar: :any,                 arm64_sonoma:  "9a62e7c34523bf7926f23d975085192cbb089d856ed120298c9cc1418fc2a6bc"
    sha256 cellar: :any,                 sonoma:        "7430e6db28920eab32a46ca0a6013abe60ff5c0bf913867444d7c596b97aba38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecbec6651a01bbe8cf87688c10bf5ef09d78913abfb537d8119ad1b18d824b86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8873a3116bfd5d3e5a3961c42a660e17875974b3cdf82e7c63d84cf326a443e3"
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