class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  license "MIT"
  revision 1
  head "https:github.comfacebookwatchman.git", branch: "main"

  stable do
    url "https:github.comfacebookwatchmanarchiverefstagsv2025.04.07.00.tar.gz"
    sha256 "792ded3402b74d62c45b2ae5ff91eefe0472ce1937cf5067b019f90b9e6a67d3"

    # Backport commit to fix build on Linux
    patch do
      url "https:github.comfacebookwatchmancommit3d91e6db2f1e0cded7abdf10cf3bfc0a13c4f61f.patch?full_index=1"
      sha256 "723a80ca790afbd942689e854abd0428438750171622f4c9a69ac65e2ac8e6e4"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4d4091a9f4743d4af0e141c50d01ac06bfa9bf118f4d74b3ab525897264d6c77"
    sha256 cellar: :any,                 arm64_sonoma:  "bd6bc898842c960d1a00407e8295d9ad336df8e18b4fa1ca2bced423337e2a21"
    sha256 cellar: :any,                 arm64_ventura: "3d1ca60d34f93930560e4b464479a151927ff0fd42db0581b72e1b99b7b86165"
    sha256 cellar: :any,                 sonoma:        "5e63e494aa91171324a7f1e12368d0eb45f81f655ad295cdd985f14bdc2897b3"
    sha256 cellar: :any,                 ventura:       "0a53a8aee9aa6ea9cb3704d6323ff7f39f0cb8d428e2a443db771542da2ce97f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "666c60ab441353a45619054dd94729deec13ee676484efedfd927881736626b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8ea0f2278a5e1f9a9ba44d932969a3f8b5d47adc5944c9a9f9b978a1752a4ef"
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