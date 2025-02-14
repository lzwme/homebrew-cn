class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2025.02.10.00.tar.gz"
  sha256 "11fd5dd7e58451c2b5b00e38c0bf31fab804d57d16c355c117c28c019bfe12de"
  license "MIT"
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "47dedd39801104f4ec40ccbd6d2c5abe5ae21eb8c88b20fe5999b8c45b3907fd"
    sha256 cellar: :any,                 arm64_sonoma:  "1cc3a7bd28f1096ed71b60d8da9b979243873d3259c8413a5ccf68c05e2b3208"
    sha256 cellar: :any,                 arm64_ventura: "db4cd1605c86916d03ea01009b4d98733d8c55345bf70f19a803df913c88f636"
    sha256 cellar: :any,                 sonoma:        "9adaf2c1c03cf1f6732855be13d3a5987e5c27ad5df3295be874574fcf10ef5d"
    sha256 cellar: :any,                 ventura:       "2bf9cdfa4f2fee0d90dde81e1591d4552a107f7fb31fac441113ca031292bdc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e87e9011b74b31da72c2bea7c9943d244e8b804140642211bd4dcc01d0f396a6"
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
  end

  test do
    assert_equal(version.to_s, shell_output("#{bin}watchman -v").chomp)
  end
end