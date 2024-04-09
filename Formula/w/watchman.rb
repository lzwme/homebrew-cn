class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2024.04.08.00.tar.gz"
  sha256 "ce6a6a2efe795c794776abc6e996617468d34e7ed845dbf755103e1fb251910d"
  license "MIT"
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c5972283fe2b2c1b704265db5fde014a278c8526f4a9b9e27d8b5599ced6104d"
    sha256 cellar: :any,                 arm64_ventura:  "5b658968e08db97f36032102040c0a4ed8305a852b1e785a2a0699a9761fd25c"
    sha256 cellar: :any,                 arm64_monterey: "c004d92e1e7817b06dd0da3228bef3a5aa3f8b6fd3debd67b118a9d218404ace"
    sha256 cellar: :any,                 sonoma:         "d9c55e745f0ddbb7eb894d115e1499c17c90cbd9f38a602d8e4006896dfe4de1"
    sha256 cellar: :any,                 ventura:        "d77b43fe67920b10a79a08c85fc8345a203d5cbe5db58accee79269d3b67a250"
    sha256 cellar: :any,                 monterey:       "099f2f18f0470b8d7b9ca61eec2c753580a6ea35def2fb7fdb86fe37c672b10b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b5851e9f4e5629cf8be67608641fe2b0adfd3a613c35781c1d973263a3e51f3"
  end

  # https:github.comfacebookwatchmanissues963
  pour_bottle? only_if: :default_prefix

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "googletest" => :build
  depends_on "mvfst" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "edencommon"
  depends_on "fb303"
  depends_on "fbthrift"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.12"

  on_linux do
    depends_on "libunwind"
  end

  fails_with gcc: "5"

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace "CMakeLists.txt",
              gtest_discover_tests\((.*)\),
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"

    # NOTE: Setting `BUILD_SHARED_LIBS=ON` will generate DSOs for Eden libraries.
    #       These libraries are not part of any install targets and have the wrong
    #       RPATHs configured, so will need to be installed and relocated manually
    #       if they are built as shared libraries. They're not used by any other
    #       formulae, so let's link them statically instead. This is done by default.
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_EDEN_SUPPORT=ON",
                    "-DPython3_EXECUTABLE=#{which("python3.12")}",
                    "-DWATCHMAN_VERSION_OVERRIDE=#{version}",
                    "-DWATCHMAN_BUILDINFO_OVERRIDE=#{tap.user}",
                    "-DWATCHMAN_STATE_DIR=#{var}runwatchman",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    path = Pathname.new(File.join(prefix, HOMEBREW_PREFIX))
    bin.install (path"bin").children
    lib.install (path"lib").children
    path.rmtree
  end

  def post_install
    (var"runwatchman").mkpath
    chmod 042777, var"runwatchman"
  end

  test do
    assert_equal(version.to_s, shell_output("#{bin}watchman -v").chomp)
  end
end