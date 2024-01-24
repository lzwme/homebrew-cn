class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2024.01.22.00.tar.gz"
  sha256 "04b789729c37bd7a8b69f632d8c9e2daf1ba0ba2a28169f208a8a2ec3125cd4a"
  license "MIT"
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2b888ccda8fd1d80401d871aa8703773df57f159f2dd03d82dafb2688191f9eb"
    sha256 cellar: :any,                 arm64_ventura:  "153024ce6a619a1e025fb4202a9381a6b2778c07d9e46d87104290188b3aba9c"
    sha256 cellar: :any,                 arm64_monterey: "20cc1eb88eacdcafed1b1bf052360f8b929260574b7493d267f57a320573823d"
    sha256 cellar: :any,                 sonoma:         "1478004b7fdb116e7a932e7361b6fb711e8cf662e72d80dc7d90d6072697738e"
    sha256 cellar: :any,                 ventura:        "5c56cc84e7a43e448ce18123dc98ddf68530647932790df6f46a1912d7a21032"
    sha256 cellar: :any,                 monterey:       "8d8f5665b41653ab92c394601d48c67d20265f5666ee81cb18ae84db002803df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e8eec883fe86e999b7c8b63b5ef70b1290f5a8da5aa2d47fd65a0383046b6b0"
  end

  # https:github.comfacebookwatchmanissues963
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
              gtest_discover_tests\((.*)\),
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