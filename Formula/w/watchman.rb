class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://facebook.github.io/watchman/"
  url "https://ghfast.top/https://github.com/facebook/watchman/archive/refs/tags/v2026.06.29.00.tar.gz"
  sha256 "cfd7f80ed6c2fa5b2e50a42c4aa6401145e0708477f6e19acb78ccb8d7d8c223"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "de8f528a9b635edf118d297a06c6da2e0adeb0fd2c68e4b2f4a587b15c076a03"
    sha256 cellar: :any, arm64_sequoia: "e57788994cd3f4c449397226d548aa5bc8b35e858a6052cbb93537ea1273c16a"
    sha256 cellar: :any, arm64_sonoma:  "6d1d2df3cbf7d27c7b7f4a5e5e93252a1a41e08d707cc995f2fca05f3bec4b13"
    sha256 cellar: :any, sonoma:        "c987566d2c7aafb23182cf96af71f215de1d3ed6eb8ad7eef7c6f027de0b64d8"
    sha256 cellar: :any, arm64_linux:   "9430e736c204d1eed05d252da957db20eb519056a24e8698edfe0be615925b6e"
    sha256 cellar: :any, x86_64_linux:  "6f0adbe0c9c17699c5197aad50904ffa0bfaa5da3e244be3e2560c36ad6db129"
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