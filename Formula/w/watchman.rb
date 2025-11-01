class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghfast.top/https://github.com/facebook/watchman/archive/refs/tags/v2025.10.27.00.tar.gz"
  sha256 "d354c17bd2c62728607632913c9c47a2de71276b0b303aee8d033f758aaff13a"
  license "MIT"
  revision 1
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "48a78faac781dc2db160fc4366afd3dde565f946e54964036c59c8e445f96763"
    sha256 cellar: :any,                 arm64_sequoia: "57188c95ba087af838c05042cad4d3f7b15c57ca628663331b954c5e3473b8b3"
    sha256 cellar: :any,                 arm64_sonoma:  "fdc2d969d043db099aaaf256a5b85a68ebad462afe300a984e1e56952a2e11b6"
    sha256 cellar: :any,                 sonoma:        "dcb9838bf88bad1a5aea2b05100478150ba304f7718f28863fdc51631e24a940"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5349180514292d3964e2b52b7eb3aee6ec26d186d976cabe7d427f4f45f77cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2f247933f1bdebdeb1f517749b75dd6331fb7dbdd0ccae7f6285c5431b93f70"
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