class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https:sysdig.com"
  license "Apache-2.0"
  revision 1

  stable do
    url "https:github.comdraiossysdigarchiverefstags0.35.1.tar.gz"
    sha256 "9fbadcde35e7084d542edccafe6426b481a489698484d81587432b06024b2ca0"

    # Update to value of FALCOSECURITY_LIBS_VERSION found in
    # https:github.comdraiossysdigblob#{version}cmakemodulesfalcosecurity-libs.cmake
    resource "falcosecurity-libs" do
      url "https:github.comfalcosecuritylibsarchiverefstags0.14.2.tar.gz"
      sha256 "b4ae7bbf3ad031deee4a808145f9fd64b71c537406cc5a92f512823b2e52cdd5"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "c6bed58c7bd3a0b19f2d04c0924685d33d1ccc811ba1c4a6146222cca77fc391"
    sha256                               arm64_ventura:  "9ae087db5c64faf4dbe35c3800f0c633743e2a56d7ea791dc9a39e7d039e368a"
    sha256                               arm64_monterey: "1071ac4f08ad434e216a6075869daa0d8a657df9122118d9d65a45408ee06889"
    sha256                               sonoma:         "a10b192bf607a66f18443928d5ed70bc4a3a1bb4bade463fe6e63deed4d84892"
    sha256                               ventura:        "f9badd75eb39c11c61ca7fe865fca2fa6c69906818ab71927ed2cf94d00bcc42"
    sha256                               monterey:       "da4f89d857b98941bd769c9d2003133aac61ee620cf2ad8c1acc22c83cfc0158"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34dc15724e80ac824906304bc3399625cebc08179568b27668ad23492b6b25c3"
  end

  head do
    url "https:github.comdraiossysdig.git", branch: "dev"

    resource "falcosecurity-libs" do
      url "https:github.comfalcosecuritylibs.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "valijson" => :build
  depends_on "c-ares"
  depends_on "jsoncpp"
  depends_on "luajit"
  depends_on "re2"
  depends_on "tbb"
  depends_on "uthash"
  depends_on "yaml-cpp"

  uses_from_macos "curl"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libb64" => :build
    depends_on "abseil"
    depends_on "elfutils"
    depends_on "grpc"
    depends_on "jq"
    depends_on "openssl@3"
    depends_on "protobuf"
    depends_on "zstd"
  end

  fails_with gcc: "5" # C++17

  # More info on https:gist.github.comjuniorz9986999
  resource "homebrew-sample_file" do
    url "https:gist.githubusercontent.comjuniorz9986999rawa3556d7e93fa890a157a33f4233efaf8f5e01a6fsample.scap"
    sha256 "efe287e651a3deea5e87418d39e0fe1e9dc55c6886af4e952468cd64182ee7ef"
  end

  def install
    (buildpath"falcosecurity-libs").install resource("falcosecurity-libs")

    # fix `libzstd.so.1: error adding symbols: DSO missing from command line` error
    # https:stackoverflow.coma55086637
    ENV.append "LDFLAGS", "-Wl,--copy-dt-needed-entries" if OS.linux?

    # Keep C++ standard in sync with `abseil.rb`.
    args = %W[
      -DSYSDIG_VERSION=#{version}
      -DUSE_BUNDLED_DEPS=OFF
      -DUSE_BUNDLED_TINYDIR=ON
      -DCREATE_TEST_TARGETS=OFF
      -DBUILD_LIBSCAP_EXAMPLES=OFF
      -DDIR_ETC=#{etc}
      -DFALCOSECURITY_LIBS_SOURCE_DIR=#{buildpath}falcosecurity-libs
    ]

    # `USE_BUNDLED_*=OFF` flags are implied by `USE_BUNDLED_DEPS=OFF`, but let's be explicit.
    %w[CARES JSONCPP LUAJIT OPENSSL RE2 TBB VALIJSON CURL NCURSES ZLIB B64 GRPC JQ PROTOBUF].each do |dep|
      args << "-DUSE_BUNDLED_#{dep}=OFF"
    end

    args << "-DBUILD_DRIVER=OFF" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (pkgshare"demos").install resource("homebrew-sample_file").files("sample.scap")
  end

  test do
    output = shell_output("#{bin}sysdig -r #{pkgshare}demossample.scap")
    assert_match "tmpsysdigsample", output
  end
end