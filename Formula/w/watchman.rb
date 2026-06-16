class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://facebook.github.io/watchman/"
  url "https://ghfast.top/https://github.com/facebook/watchman/archive/refs/tags/v2026.06.15.00.tar.gz"
  sha256 "769b1d252f691d9437fb2a2e51289237a781591c80954567d2b0c57e715564ec"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5399d2df47e2ed9fe5d047620c8914d1cb7b6103b5d1e29d4e348cd4215fc340"
    sha256 cellar: :any, arm64_sequoia: "50f1726264ee8a9177bbb7d5cad63f0806901e001b2c950193fe2ecacb4aa414"
    sha256 cellar: :any, arm64_sonoma:  "33f3f8016373ed20ac73a600370bcb8e274f1277c166434a3519eec9f9f8a619"
    sha256 cellar: :any, sonoma:        "1fce523c6580ed54aa6aa0c7ecd582725874a46b9b2e2ead94e6320fc4c83d7e"
    sha256 cellar: :any, arm64_linux:   "790f9fdc77a2bc3d1832b5aa64d8195ec8a31325f37de90e1f1bdb236a1cb4e4"
    sha256 cellar: :any, x86_64_linux:  "431e372ce5bf2c72ab99c64825aa38b9e83973cbacf782f1962b2f470d2e6cce"
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