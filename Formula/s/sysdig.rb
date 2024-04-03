class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https:sysdig.com"
  license "Apache-2.0"
  revision 1

  stable do
    url "https:github.comdraiossysdigarchiverefstags0.36.0.tar.gz"
    sha256 "2e519bfa7e6af885cf686f3f85a16fb398c3eb5a6763da7ff8e4ba570cdc2701"

    # Update to value of FALCOSECURITY_LIBS_VERSION found in
    # https:github.comdraiossysdigblob#{version}cmakemodulesfalcosecurity-libs.cmake
    resource "falcosecurity-libs" do
      url "https:github.comfalcosecuritylibsarchiverefstags0.15.1.tar.gz"
      sha256 "8c2596fec3c25e9718a8b357b0504450cd26efbe653b79afcd66a8405f0dc08c"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "0bbfbf372a7afd0f5a0971ff37ddc09325b7344858e6339d4e99cc7fbaecc643"
    sha256                               arm64_ventura:  "4ffbe9c26307cd563a8a504715cac824a662f95de53dd11b24df5389e37a8d90"
    sha256                               arm64_monterey: "25269bc044fc9bcbadbc2c6663b0ea9023d90226f0055bbb4d0791231b99db83"
    sha256                               sonoma:         "70f6ebb0ab672d96ccc0253fb92fd8ca611fa0998a9a9c88d261636c8fdbb4ec"
    sha256                               ventura:        "9ef7a1ab88fc59bdeceaa8b7cf53ed996c4991ffaeb0665d493d6fd3997972bd"
    sha256                               monterey:       "aa9b5c44cd82574da272ce95661f15ed3a025196270609cffbd7ef56ec1d6137"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0855c5111c9d58f31569c8879b671532fb5346be95ff1dfcacd3aa3261d5bd13"
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