class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghfast.top/https://github.com/facebook/watchman/archive/refs/tags/v2025.11.10.00.tar.gz"
  sha256 "b40fcd0daa648baa704baf3b0aa4e998ba3b2ff4f109f9b89ec0afe48f6aa06b"
  license "MIT"
  revision 1
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "704e22af00a9580b79f7e7677c5206a35b60c2a2e2f9c334523138ba76900d58"
    sha256 cellar: :any,                 arm64_sequoia: "bdbf2e15e4fea4b0664063740c4dd97e7acae05a0fa325ea8f7f1e8ffa0f5ee0"
    sha256 cellar: :any,                 arm64_sonoma:  "ef0939174df18a7a622dafcb14d1ef079c22fcc1afadbba0ec03319c0ea50282"
    sha256 cellar: :any,                 sonoma:        "4c7d07abd9859a988f85ea4ef19b74e2854f9453f13e0686bd8068776a72c69c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9507d8b6e585488c632c46e9cda578a0f76a8f252e82dcc85a98435ec4d8dc65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "748e8cc5dd75cb1ca078260ab0ed08a8d8d054678c79b938b8785aa0d56148d3"
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