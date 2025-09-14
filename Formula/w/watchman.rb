class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghfast.top/https://github.com/facebook/watchman/archive/refs/tags/v2025.09.08.00.tar.gz"
  sha256 "11d2cd309148eb83be4ec79494eb2b566361e671ad4d72a418fb80e8b9895945"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b52da1c182f4818769d80df989c0fb511fc3d15a014c70c63f0845f249447376"
    sha256 cellar: :any,                 arm64_sequoia: "5cd2265e6a105b5cfb794c8c7c32eb7e053a939b1939bbcdc06b0766e714620d"
    sha256 cellar: :any,                 arm64_sonoma:  "05951f0411d9474b5cb90f2c34a7c3eda2f6f413ac562d845d0750740e78e2e9"
    sha256 cellar: :any,                 arm64_ventura: "d680c7995754e9867e2702d23626008e9cffae585e8d6621201c009a60be3d7e"
    sha256 cellar: :any,                 sonoma:        "4960bb76f711308d5da3d3d7f46214756ed321958ee65391f690feba5b482247"
    sha256 cellar: :any,                 ventura:       "64a6c6895e84ac266170ffa0699e743b76dd89f41d63e749f2a633dc1c56a0bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "046e04cb8923c880456a88a080c70b062e54a9f95a24f9cf6d29263c21878fb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c734be836bebe056c9085125020d645c1e728b1a952bcad5e97a12518357ccb3"
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