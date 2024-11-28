class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2024.11.25.00.tar.gz"
  sha256 "0be6415d20e6a8a39246e177d8ec4452dad98fd6085397bed825b8f71acaf305"
  license "MIT"
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d9655b2dcfb50ab9d746db2387891aeacc2b56d58a805a3d8c47ebc885ef3a03"
    sha256 cellar: :any,                 arm64_sonoma:  "2d8e675b59976097a3301a9189f9a02be14ff29dd64115d0096cf42e2aeab35d"
    sha256 cellar: :any,                 arm64_ventura: "6da9d2d18df0298918afb5f87f4c74b8ede02f67fdfb6e4c855d8e9ffee2cee2"
    sha256 cellar: :any,                 sonoma:        "fea1bef225a3f1178319334777473b6d304690c79f4f1ddd2795e59122b7db88"
    sha256 cellar: :any,                 ventura:       "0b808e134b07d5a1d393c5760374e0dac87d127a1281e53fbfb989445fc544c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c1b58edb12453b06ffc6f4cd7cdc09805eab3212dd1d011367546dd3777c4c8"
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