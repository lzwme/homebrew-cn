class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghfast.top/https://github.com/facebook/watchman/archive/refs/tags/v2025.09.01.00.tar.gz"
  sha256 "3aafc60e96e164b5a368523f0899eb8daaa79e126b30a6a67f06db1949bcbce0"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6d2676f36a8216e7b100bc6be437b840a0217370de73f17f86f136892abb5a5b"
    sha256 cellar: :any,                 arm64_sonoma:  "c960984147e6ec95a1d84425d21250345228b9367e76766dc5a6d26a29b5109a"
    sha256 cellar: :any,                 arm64_ventura: "acc9d4e83d1fcd14c55ddd38f4d05062235d5eb5ee17f6c92a42f500e3059ffb"
    sha256 cellar: :any,                 sonoma:        "724e3a5ed861cd8c686ce34c335ba67cbe07c3980841b0f2e8e5ef118a34b7fe"
    sha256 cellar: :any,                 ventura:       "83a3f8a5d7ad6fc39fb43619fa95689b77e5661a02fac69cc1b20c7aabc5b7f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57904425282409cc680db450e6995004c652e72c3b5903f0c5f3f1aacafa6c0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a7a079348e7b8e3297bdb2ca0e84b282dd302b7d36f50c9189daaccc62b1445"
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