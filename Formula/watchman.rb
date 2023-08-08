class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghproxy.com/https://github.com/facebook/watchman/archive/refs/tags/v2023.08.07.00.tar.gz"
  sha256 "8158efc9a6ecf56dbfd2c52cfd6689ca073655b909bf61100c0f88bf5c0b0720"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6fa4f872632a9da4ca29a5c0be58da189b85f5de4e34be6baf36c442b0ffcc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76d7da58f86cf619f383ed4bf9944e313f6a9c87f196b5a3ea5055a7033b3d4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b81254ef59de4fc1103e8371ae5072f1fc66d41f121136813859b5a73b87e6f"
    sha256 cellar: :any_skip_relocation, ventura:        "c91e2d023df15a34b94cdde3e95b4abeeb11230b0c4ea6407c96b4a290a987b7"
    sha256 cellar: :any_skip_relocation, monterey:       "619bc2f324bfd4884a891a9ecdf51ff2b8b87ab25e976d2a2f2a05e139db998e"
    sha256 cellar: :any_skip_relocation, big_sur:        "51c6a36b4692d7012803b71db0d224386a2f213165764be64891401e1122924d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ae6f550244f8118819269319915503ecdd25410412c2d034d84bc70cf140685"
  end

  # https://github.com/facebook/watchman/issues/963
  pour_bottle? only_if: :default_prefix

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
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
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.11"

  fails_with gcc: "5"

  # Add support for fmt 10
  # See https://github.com/facebook/watchman/pull/1141
  patch do
    url "https://github.com/facebook/watchman/commit/e9be5564fbff3b9efd21caed524cd72e33584773.patch?full_index=1"
    sha256 "dc3ef949b0a4be7dd67267eb057fb855926b3708e0ce1df310f431fd157721ca"
  end

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace "CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"

    # NOTE: Setting `BUILD_SHARED_LIBS=ON` will generate DSOs for Eden libraries.
    #       These libraries are not part of any install targets and have the wrong
    #       RPATHs configured, so will need to be installed and relocated manually
    #       if they are built as shared libraries. They're not used by any other
    #       formulae, so let's link them statically instead. This is done by default.
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_EDEN_SUPPORT=ON",
                    "-DWATCHMAN_VERSION_OVERRIDE=#{version}",
                    "-DWATCHMAN_BUILDINFO_OVERRIDE=#{tap.user}",
                    "-DWATCHMAN_STATE_DIR=#{var}/run/watchman",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    path = Pathname.new(File.join(prefix, HOMEBREW_PREFIX))
    bin.install (path/"bin").children
    lib.install (path/"lib").children
    path.rmtree
  end

  def post_install
    (var/"run/watchman").mkpath
    chmod 042777, var/"run/watchman"
  end

  test do
    assert_equal(version.to_s, shell_output("#{bin}/watchman -v").chomp)
  end
end