class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2024.08.19.00.tar.gz"
  sha256 "ba6bdb8c565ac72036ec4eed940d3907c9138c7c329bf6035bfbc0202c335008"
  license "MIT"
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8dcc99d9d52921eb7134451058c0d3839f8e50f8f0dd5fe3b88618812214c037"
    sha256 cellar: :any,                 arm64_ventura:  "91cc98b27e3024a9a7239e09b12b4a2c466ddba55dec9884d611599f8287280c"
    sha256 cellar: :any,                 arm64_monterey: "c1350186ebb1a92d6554673ddec0d64037d68bd28e6e9c31a2ac2c0f6b65434c"
    sha256 cellar: :any,                 sonoma:         "0f30c88943db4b76841d0d445b5ecd0741abd7f71327478af85f409a325efee4"
    sha256 cellar: :any,                 ventura:        "8ae25d0663f337529452690386ece271baa06d615c7e06c49b6a9dbbd370a1fa"
    sha256 cellar: :any,                 monterey:       "06db9d1379052053e51722aee935e694b0e8769ae04402e7ca3fe02fcfb4c117"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df770d4b48e433b697452ea483888cbd2ee102dcfc2a68ae05e1418b6dae476b"
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
  depends_on "python@3.12"

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
      -DPython3_EXECUTABLE=#{which("python3.12")}
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