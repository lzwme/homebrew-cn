class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https:github.comfacebookwatchman"
  url "https:github.comfacebookwatchmanarchiverefstagsv2024.07.01.00.tar.gz"
  sha256 "d56a1672802c5ea0b9b853a3a9d1dcf1644d72a56e5c6069db6319310b271d32"
  license "MIT"
  head "https:github.comfacebookwatchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "73886555afca55bab7b6e0cb136e0fdf02f895771f2fdf926a7d40e0d880a450"
    sha256 cellar: :any,                 arm64_ventura:  "80e4c78cc9a83a0a33c2a807b6e4a7757223257883f6c7b279a15b88fa8d4033"
    sha256 cellar: :any,                 arm64_monterey: "357ea33d8acbd1037f3b47ff31178609276cceb3602e2673b01ed5fc2fd8f865"
    sha256 cellar: :any,                 sonoma:         "58728609a286fe6a24e7c9610fb1fc59bdecb15eedf0f008971403ec1219dc4f"
    sha256 cellar: :any,                 ventura:        "1576bcabee5e23af1d8495c374cb0992a3f633fdc5b0bcb5ac0a87d1f0676e14"
    sha256 cellar: :any,                 monterey:       "1e2fb41efb6bab128e93ce8198ad1d66190f11d0db39fd3bc3e08c96e46ddaa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da891b72c3e65ed334034b974e784757a117d6e7aac5f0d9b7126a57bc952809"
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

  # watchman_client dependency version bump, upstream pr ref, https:github.comfacebookwatchmanpull1229
  patch do
    url "https:github.comfacebookwatchmancommit681074fe3cc4c0dce2f7fad61c1063a3e614d554.patch?full_index=1"
    sha256 "7931c7f4e24c39ea597ea9b125c3003ccdb892292fc455b4c66971c65a48f5f6"
  end

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