class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://facebook.github.io/watchman/"
  url "https://ghfast.top/https://github.com/facebook/watchman/archive/refs/tags/v2026.07.13.00.tar.gz"
  sha256 "3fe1b0bf085537191a89a0823810aa75a29962dc3e2243a608c675a6fb1f6d18"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c900e7573caec6bf677a08bf918b5463af5c87364a7b2100b6ba6213c3dc3c4d"
    sha256 cellar: :any, arm64_sequoia: "6dc34fa63844bd453eb8c226050965b7dc2174fe82e979a01f33b4c7c9fd3146"
    sha256 cellar: :any, arm64_sonoma:  "dfcb1a0c441cce6ea03f3d73a2195dee1dcab625d0dd19c6393b06dcaee0ff1a"
    sha256 cellar: :any, sonoma:        "1e306568698eab016eb91a58916348001a10f7d576b815287dd2645f36e998ec"
    sha256 cellar: :any, arm64_linux:   "add5ba0a965bdb398c2c2856aa65913639a1c8159014062178e65124646d6d85"
    sha256 cellar: :any, x86_64_linux:  "aae54a4037a19a1e65c476dfb3d9285414f692fe881c3a507daf6c60891e72e1"
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

  # fmt 12.2 dropped fmt::format from <fmt/core.h>; include <fmt/format.h> where used.
  # PR ref: https://github.com/facebook/watchman/pull/1348
  patch do
    url "https://github.com/facebook/watchman/commit/7dbd77e849641ec756fee53a587da56d4502b4d1.patch?full_index=1"
    sha256 "5855728d86bca5c11d08195db93659da91a813ce7a5c0293366aafe08970364a"
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