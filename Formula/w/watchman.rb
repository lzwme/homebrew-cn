class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2025.06.23.00.tar.gz"
  sha256 "ca8f92a19b6394b11af1c3655947d370cb9e7f5dd6bf4f298bd4e012f2f4f8b1"
  license "MIT"
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dd650300246893fd7aea89e025f1813963c5caaac1c390ccafe1c354826ba1fb"
    sha256 cellar: :any,                 arm64_sonoma:  "83dd5a77ca35db070856dcc585a60326646f67cc0ec79d06f865822199cfa5a0"
    sha256 cellar: :any,                 arm64_ventura: "7be6aee152a7727326293c85c49f89549bfd97c0e15714dded1fbf1a274cb625"
    sha256 cellar: :any,                 sonoma:        "88774a04346e20520797979a6b3d7a81f456c03b52c8bcc8965519c0fd6ca3e8"
    sha256 cellar: :any,                 ventura:       "a9363af979bacd7e914108c1501a4c6b283947424cc2d31bf78e3d9dca2aa923"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b2070e9329266b7a44174243136dbe99d94adcccad7d09f1420fc247a130834"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07b518fc9cab565038ec9d49948c812f77ebbca698a9f861a192a0b69c120917"
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

    rewrite_shebang detected_python_shebang, *bin.children
  end

  test do
    assert_equal(version.to_s, shell_output("#{bin}watchman -v").chomp)
  end
end