class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  license "MIT"
  head "https:github.comfacebookwatchman.git", branch: "main"

  stable do
    url "https:github.comfacebookwatchmanarchiverefstagsv2024.06.17.00.tar.gz"
    sha256 "70c70101af0fdfd12386bc2529bd61f1e34f5d0709e155ba06d6457028685298"

    # rust build patch, upstream commit ref, https:github.comfacebookwatchmancommit58a8b4e39385d5e8ef8dfd12c1f5237177340e10
    patch :DATA
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fcf5691a1b200cd867fd382c6800525cdd2d4f974dd07691da3c17d3eec1b3d8"
    sha256 cellar: :any,                 arm64_ventura:  "c2ea954636895ea1b398ee842e8020ce9cad4339bfee1d6aa5d449015f0405c5"
    sha256 cellar: :any,                 arm64_monterey: "07f9d12fa7b930106d73c39f0b7473e12d2b375ff1503440bd15176be6b1cdd8"
    sha256 cellar: :any,                 sonoma:         "650426e049ac9f23de1f4175f318e4de9c103b6a36ebc2933cba2bf9987046c7"
    sha256 cellar: :any,                 ventura:        "75e1f8b3f1fbcce0207294a005462de9b8653fc7f59563c00b19258641f70157"
    sha256 cellar: :any,                 monterey:       "1a40aca3dbd803a899238c726031a68312ddcc670413b1c49b68e94c5357b13a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "693c8b0144090c1163d0f4a47bc86bd14cc526044323d03e2f6196cc50e078a6"
  end

  # https:github.comfacebookwatchmanissues963
  pour_bottle? only_if: :default_prefix

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "googletest" => :build
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

    args = %W[
      -DENABLE_EDEN_SUPPORT=ON
      -DPython3_EXECUTABLE=#{which("python3.12")}
      -DWATCHMAN_VERSION_OVERRIDE=#{version}
      -DWATCHMAN_BUILDINFO_OVERRIDE=#{tap&.user || "Homebrew"}
      -DWATCHMAN_STATE_DIR=#{var}runwatchman
    ]
    # Avoid overlinking with libsodium and mvfst
    args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    # NOTE: Setting `BUILD_SHARED_LIBS=ON` will generate DSOs for Eden libraries.
    #       These libraries are not part of any install targets and have the wrong
    #       RPATHs configured, so will need to be installed and relocated manually
    #       if they are built as shared libraries. They're not used by any other
    #       formulae, so let's link them statically instead. This is done by default.
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    path = Pathname.new(File.join(prefix, HOMEBREW_PREFIX))
    bin.install (path"bin").children
    lib.install (path"lib").children
    path.rmtree
  end

  def post_install
    (var"runwatchman").mkpath
    # Don't make me world-writeable! This admits symlink attacks that makes upstream dislike usage of `tmp`.
    chmod 03775, var"runwatchman"
  end

  test do
    assert_equal(version.to_s, shell_output("#{bin}watchman -v").chomp)
  end
end

__END__
diff --git awatchmanrustwatchman_clientsrclib.rs bwatchmanrustwatchman_clientsrclib.rs
index a53e60a..dc315fd 100644
--- awatchmanrustwatchman_clientsrclib.rs
+++ bwatchmanrustwatchman_clientsrclib.rs
@@ -587,6 +587,7 @@ impl ClientTask {
         use serde::Deserialize;
         #[derive(Deserialize, Debug)]
         pub struct Unilateral {
+            #[allow(unused)]
             pub unilateral: bool,
             pub subscription: String,
             #[serde(default)]