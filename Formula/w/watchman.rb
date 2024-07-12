class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2024.07.08.00.tar.gz"
  sha256 "140f5ce335cd2639945e45e778f5203581add5fc30e64a166ee37140fe8970e4"
  license "MIT"
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3ade44c790eb49178789ce23506ade13564194b7ff0a0dd03d4c6b2cb03501c4"
    sha256 cellar: :any,                 arm64_ventura:  "12b550ae38d82fe6dfe2580f648e3a4aa7acc0cd0015f11debb758eba0e4fa3d"
    sha256 cellar: :any,                 arm64_monterey: "f0eb354ee7b6fd7f4bf62a63ff64915bb0bcbef69c1d633c230e4fb9a080007d"
    sha256 cellar: :any,                 sonoma:         "1fa07b70d9673549687c4d3d542655a660b727d02ec6bdf9195b98867182447b"
    sha256 cellar: :any,                 ventura:        "4370738864cf96d1d03b23847c2d89f4cb5ede1c3885b2c136ccdd47cca17816"
    sha256 cellar: :any,                 monterey:       "0c95c2baae9dd51e6e68b7a7c72061640925ea7fce7fca8c2eee84828132fcd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54388aaebced4de7927f7c7c3ba45b319842ee4e8494cb8ffd76f0df091c89fd"
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