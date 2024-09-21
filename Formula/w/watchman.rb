class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2024.09.16.00.tar.gz"
  sha256 "30f93245c51cdfe571249b660f9e8c7a5c0d246375c3e7a4c666984af7d30a8d"
  license "MIT"
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "743348a79911c3796002217c65a8cfb6b067d5f5814340e8baa104c2e73b017b"
    sha256 cellar: :any,                 arm64_sonoma:  "517cc7a5b20241233b0ddf19d71399fe7ba37defd7b36b78a9f75ad6256a8714"
    sha256 cellar: :any,                 arm64_ventura: "67c22507c586945fffd1c922f35545e135b77bfe3b2b1110014c51bcd7f0f04d"
    sha256 cellar: :any,                 sonoma:        "8e1efec981da3f8e4a1c32fb8bf89de7007da0da896dd6c4c2ab04b4a1214002"
    sha256 cellar: :any,                 ventura:       "0d67097c3c83a7fc52f88ea249bde447e3800a6738a8248f537978020306970a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f134b1f8ba74f5d563b9499b89c2465202764a43754df5645c099c3c5ba7a9d6"
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