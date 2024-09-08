class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2024.09.02.00.tar.gz"
  sha256 "a31b9633384e8635ada97a55fc04b5f58eb271f7986d20806f21ffe9e681d545"
  license "MIT"
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4825e6085679aaa572052fd66652fd5a2e06765917857c91850b74fc77d91aee"
    sha256 cellar: :any,                 arm64_ventura:  "ad977e2cde509edcd5bd60f1ac1eb4526286f48201533911eb1f23155f70a6ea"
    sha256 cellar: :any,                 arm64_monterey: "bbea70c4b5db225d102e3559db9316031916ad4821ff7af3593d148d715cfca3"
    sha256 cellar: :any,                 sonoma:         "3db673faf9311094cd09eb50d460cdadbded702c9bb2afcfb8e58be75ca40868"
    sha256 cellar: :any,                 ventura:        "1686b9563b2d623354d3fda0799a54ed2ffb3757b69c6c6b47558ed408f75a34"
    sha256 cellar: :any,                 monterey:       "54ffe911d90aac434269d7bc34fb9964fda37c58085d80c94cbd6d47b7620bbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ea28bca34af74b88fad991de487a58ef0fb4d0f8515720dd8ceb79031bcdc18"
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