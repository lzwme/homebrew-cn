class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2024.11.11.00.tar.gz"
  sha256 "f9b902fa58855b4354726466f3454679594b950bd59250716768a2c28907cd2e"
  license "MIT"
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "45fe83d3bc56ca47c82c7c31a91e7ae53915aa268532b0ae5fab6e102d17877d"
    sha256 cellar: :any,                 arm64_sonoma:  "dda7be87d7569fb185f6c47f3043b1ea02fe05cdb6ea4c145ce59583d03e3ad5"
    sha256 cellar: :any,                 arm64_ventura: "922159ed7e190b7193f3886b81bd3d4d83e665e805e76cb48b53c494017b72eb"
    sha256 cellar: :any,                 sonoma:        "8f942690f93577234b7844965d3f91d028ea0cafb7e27ff1b929eaa9ac9416bf"
    sha256 cellar: :any,                 ventura:       "a2984abebd30d5b9f8dc0079099a11d5e233646f95f49ecd022ae5525694cae0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "371ec979e56a34e84d2fcc01d9835e8df7202c8b565d7594345a7d4f1292c6d9"
  end

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "googletest" => :build
  depends_on "pkg-config" => :build
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

  fails_with gcc: "5"

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
  end

  test do
    assert_equal(version.to_s, shell_output("#{bin}watchman -v").chomp)
  end
end