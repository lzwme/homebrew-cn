class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2024.08.26.00.tar.gz"
  sha256 "c5989f5f0f64956ab80e09f8ef32de1a022e59b5dbee89985e626d3c1ad6ea79"
  license "MIT"
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "519869ebc5be636f42ff2591d08572821eba872c1516de2b90d431fd135fb2ac"
    sha256 cellar: :any,                 arm64_ventura:  "0d04b0ea08d0c21bef79ef79cbb0aa4d52462040082e6ba2ba45baa44efa035f"
    sha256 cellar: :any,                 arm64_monterey: "7491713673cb2ab01e78597e6165f9282d065f318b124df2f2df1ddb2aebb93d"
    sha256 cellar: :any,                 sonoma:         "3abad9aa284cad39d0eacd9b05cc4dc879f26e55bb574ebbbdfc88377bcd110f"
    sha256 cellar: :any,                 ventura:        "56633f080d4aeb3fcb4555a556655259dad4eaf857a1239e240edcb5c5c7003b"
    sha256 cellar: :any,                 monterey:       "11179f0d6c91b9062f313fd3c9af42207b338870ea68ed9b2a18b3789239857f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea12a5fe08c24905ddba884aa32de5e2e787563b829f3b58490894e0694cba8d"
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