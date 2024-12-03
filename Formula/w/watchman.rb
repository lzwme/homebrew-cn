class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2024.12.02.00.tar.gz"
  sha256 "445bda6f262cd23ed305f914249e400c7377ebe21ec971a2ace6c1c3dfad5880"
  license "MIT"
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6adf1c598ff74d52bbb6e6019588ea2c088683a0d45fb74e39c2675aa154ed94"
    sha256 cellar: :any,                 arm64_sonoma:  "98ed340b58fce54b27f5f4ef91ccf31949611327d086ce183eae77ab95729184"
    sha256 cellar: :any,                 arm64_ventura: "4cdc6893cc2dc54720495c378b7d8076b58cce2bc189330033d6b9bf77566f83"
    sha256 cellar: :any,                 sonoma:        "3ab65ac543b5e2e6cf937355cd4b19e16c6bd47b1ced1f70ad42f44ba87264bc"
    sha256 cellar: :any,                 ventura:       "174d3c72459adf70ed117edb479b766b1ceae5f41488bcdb6a47e9f6340f1a68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e2aaf0e7ca686132f797d47c20b66e1d6332285eaf84074bcf03e04cbe60399"
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

  # Workaround for https:github.comGuillaumeGomezsysinfoissues1392
  patch :DATA

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

__END__
--- awatchmancliCargo.toml
+++ bwatchmancliCargo.toml
@@ -16,7 +16,7 @@
 serde = { version = "1.0.185", features = ["derive", "rc"] }
 serde_json = { version = "1.0.132", features = ["float_roundtrip", "unbounded_depth"] }
 structopt = "0.3.26"
-sysinfo = "0.30.11"
+sysinfo = "0.32.1"
 tabular = "0.2.0"
 tokio = { version = "1.41.0", features = ["full", "test-util", "tracing"] }
 watchman_client = { version = "0.9.0", path = "..rustwatchman_client" }