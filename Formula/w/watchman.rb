class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2024.01.15.00.tar.gz"
  sha256 "3d8880056956696bcfb7c549d446e13b73f2c383851de53ef5e3a8f52068a3d9"
  license "MIT"
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b6aee4cefdc58e3e2dd4ebc550b7ac96ab275da03fe7296fe73c8fb86ddd15bf"
    sha256 cellar: :any,                 arm64_ventura:  "3d035234781b02c103ea398990789a3bf2aed371c90a7bd9a3b7a7b9efe80906"
    sha256 cellar: :any,                 arm64_monterey: "010788bd752f2032398104c13e3786d501ac4ef8d9c62522384c05f3b610c384"
    sha256 cellar: :any,                 sonoma:         "4071aeddde84544cc58b6ac035f4642807f7b8badeba2352ac077b2d2e5814c9"
    sha256 cellar: :any,                 ventura:        "b26ffe7ba73a92012b956b4ee58605e617ad734c364acf83e5ec65a254f1a18c"
    sha256 cellar: :any,                 monterey:       "0805cbdd4188e6f943df99752db63981c7a2db11afd92f618383e2362c6b9055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cd3504e421b57ac497a9c298454309a718fbb30d2eecae69a82d89ccf3e5a33"
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