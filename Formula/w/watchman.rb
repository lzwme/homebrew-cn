class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghproxy.com/https://github.com/facebook/watchman/archive/refs/tags/v2023.11.06.00.tar.gz"
  sha256 "7bf0c100fa23c092970c20a6dc5ec5abf854a456209ab6dca091814031c57d00"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6487ca364b75ac7efe99e9d69e05f274df42d31e7841f33b5e8306ba325cc5b8"
    sha256 cellar: :any,                 arm64_ventura:  "4ac0a88d98504190ebb546442b34422219b9ab6196b66b2a9296b0f4a91fd168"
    sha256 cellar: :any,                 arm64_monterey: "dad0ec51eee477135891ec82a023cca77903da1ae6bbbb83ec4b771745b276da"
    sha256 cellar: :any,                 sonoma:         "50bff36761367907f882071df0187b1c836bacbb9addf129abd2dcf1cc614ee2"
    sha256 cellar: :any,                 ventura:        "8fd036072c856361347275ff70aa24334d03f1e32f5a803113ac09c7b7ca2375"
    sha256 cellar: :any,                 monterey:       "6a3cf9ffda01d3c6f8f9b982d808fb4bc53f066a4319d28169520f0322804b47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d3ac6aafbfa8015a7cd966784c774e08c73cdf7cd656b279ec35c613358c864"
  end

  # https://github.com/facebook/watchman/issues/963
  pour_bottle? only_if: :default_prefix

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "fbthrift" => :build
  depends_on "googletest" => :build
  depends_on "mvfst" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "edencommon"
  depends_on "fb303"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.11"

  fails_with gcc: "5"

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace "CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"

    # NOTE: Setting `BUILD_SHARED_LIBS=ON` will generate DSOs for Eden libraries.
    #       These libraries are not part of any install targets and have the wrong
    #       RPATHs configured, so will need to be installed and relocated manually
    #       if they are built as shared libraries. They're not used by any other
    #       formulae, so let's link them statically instead. This is done by default.
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_EDEN_SUPPORT=ON",
                    "-DPython3_EXECUTABLE=#{which("python3.11")}",
                    "-DWATCHMAN_VERSION_OVERRIDE=#{version}",
                    "-DWATCHMAN_BUILDINFO_OVERRIDE=#{tap.user}",
                    "-DWATCHMAN_STATE_DIR=#{var}/run/watchman",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    path = Pathname.new(File.join(prefix, HOMEBREW_PREFIX))
    bin.install (path/"bin").children
    lib.install (path/"lib").children
    path.rmtree
  end

  def post_install
    (var/"run/watchman").mkpath
    chmod 042777, var/"run/watchman"
  end

  test do
    assert_equal(version.to_s, shell_output("#{bin}/watchman -v").chomp)
  end
end