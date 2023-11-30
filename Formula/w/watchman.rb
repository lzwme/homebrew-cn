class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghproxy.com/https://github.com/facebook/watchman/archive/refs/tags/v2023.11.27.00.tar.gz"
  sha256 "2bed101e3f18641d45e07b80c003106c4f25ac38d6a7029989e8257eebce3e9e"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "75951f7072a201e100d23b82e080929b0704507524b079b6d70c3908f25211d4"
    sha256 cellar: :any,                 arm64_ventura:  "5e7e45e8ef5f5047d5a8973273708c0a6293b64266c4c9ae2ebe055fbf9a3ae4"
    sha256 cellar: :any,                 arm64_monterey: "5d695409300aeaee0ebb8daf867608b7ccfb41e80d1af45d350ba422f93ce76e"
    sha256 cellar: :any,                 sonoma:         "9b0f5bcf558d2b11d46b5d9e3b59b3df8838a0fc251e033bd25b60cf177570f4"
    sha256 cellar: :any,                 ventura:        "70dff4e83f4be0b822d18987753c7b985528e1044ee6b7a19ed3bb6b028b4933"
    sha256 cellar: :any,                 monterey:       "8f07059e3c1fcc6882925e6e824e8ad9a525a4eae85ffe89b7a03cdbbf8c7a9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a170cb063dae01f1c368caba2689e39d8ac85bf1d0464650bf0d1764ed0a014b"
  end

  # https://github.com/facebook/watchman/issues/963
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
              /gtest_discover_tests\((.*)\)/,
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