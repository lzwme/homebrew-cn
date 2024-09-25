class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2024.09.23.00.tar.gz"
  sha256 "1fb35149ed09c641f7d8075a79820f93e805cf390b899bbdb08f6cf68b2562c8"
  license "MIT"
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "07f6a7a559df46c7cf5b335aae4a810bc78ce58700f26fa1bbe4e6e6ff337e39"
    sha256 cellar: :any,                 arm64_sonoma:  "55a37f5dad38923dce670fe113379b411e88101a0073d8523fb65ce24726f0c8"
    sha256 cellar: :any,                 arm64_ventura: "8f8e738d0b98fac6db02234ed7d3a6601948decde7b1238ba3b1d653d45b43b3"
    sha256 cellar: :any,                 sonoma:        "78120f6fc90172598c2f05a379744b25a452b9fe5b03e0dd4320fe6aa456ce16"
    sha256 cellar: :any,                 ventura:       "7f818d3ac36ee8b834ef22530e636db13819a7fbc4ea03cfb1ad4d66ee4c9b88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a097b36bca2d71114a925c92c06615693d9434bdd2364a306beaead04831b141"
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