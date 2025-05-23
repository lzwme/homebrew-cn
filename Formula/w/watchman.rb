class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2025.05.19.00.tar.gz"
  sha256 "2098af2abbf0c45bc0b5378c282458f06975a412fc2ec3252e2c62bf5aed8126"
  license "MIT"
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "54caf1a6419e8b9bd2a813d3270a5a8f41b34f8396a9950100f2bf2a5bbb99f1"
    sha256 cellar: :any,                 arm64_sonoma:  "ef54487240b27df0efc5d5abcff83c3cbfcbe7982957094b4495a4a8b86791f8"
    sha256 cellar: :any,                 arm64_ventura: "0b3fdcb42a57afabbe15524b107be76af12883bf4212e81206e5cef26976a9e5"
    sha256 cellar: :any,                 sonoma:        "c9812c81dbe2fe38a7baea8122b4f5b062cdda6e7b75905acc7a86bf3f273a50"
    sha256 cellar: :any,                 ventura:       "c3e012fd2fdbeec6e44841a9a93a6d6c48123d82fbc4a553f9c321bcbfc81403"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "763dff57c8e25fb4b6ebd3b970bdb3cb74f2596637913e5bedf310203d7ada47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a80ec240355d1e3f6d37eddde4cfa3a2cc01a560b45baa6c336f2b6f35e3a9b8"
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
    bin.install (path"bin").children
    lib.install (path"lib").children
    rm_r(path)

    rewrite_shebang detected_python_shebang, *bin.children
  end

  test do
    assert_equal(version.to_s, shell_output("#{bin}watchman -v").chomp)
  end
end