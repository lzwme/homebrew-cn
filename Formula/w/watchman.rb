class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2024.09.30.00.tar.gz"
  sha256 "ef133090311353efcdcfc77c8d3bc67dd76450c317ec0b31eeeb84a665276494"
  license "MIT"
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "94c4517fae44e073791aa487f696c42d8cae4193be104423a1f530f61d8c13f8"
    sha256 cellar: :any,                 arm64_sonoma:  "e7b575c7c299a7b8082aaf31a16baec3ed09a6655557c7f0f38039ceb37536f5"
    sha256 cellar: :any,                 arm64_ventura: "7503504ea56d2d1eaf1ebbd8583a7b29cc0f05db92513bd00fb8e0af04699066"
    sha256 cellar: :any,                 sonoma:        "289d402b4b9a7b299bad62cb365cd27f4a2e9c1e63df5c0b0add791290206f34"
    sha256 cellar: :any,                 ventura:       "b932761bd79ef4507361e992c346c44e5b270efe00d0bb9f9e6f64e72a9b4231"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d40b8eab4ba1b515335a747b3f197615ca86855a1e5fe129e8d0d4dc33766e73"
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