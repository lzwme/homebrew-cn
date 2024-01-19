class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https:sysdig.com"
  license "Apache-2.0"
  revision 1

  stable do
    url "https:github.comdraiossysdigarchiverefstags0.34.1.tar.gz"
    sha256 "840a9099b66984c6ba71bb750b9440fb51c508d06e97e20d152c4f9a5e50d757"

    # Update to value of FALCOSECURITY_LIBS_VERSION found in
    # https:github.comdraiossysdigblob#{version}cmakemodulesfalcosecurity-libs.cmake
    resource "falcosecurity-libs" do
      url "https:github.comfalcosecuritylibsarchiverefstags0.13.1.tar.gz"
      sha256 "2be42a27be3ffe6bd7e53eaa5d8358cab05a0dca821819c6e9059e51b9786219"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "9fc305342a57f9c42116ebed374bdd9165074427af200c4d2feb92df883d30c2"
    sha256                               arm64_ventura:  "33cb58fc0f949f657a85d8e185c973946d80f0ceeffc259231cfea075cbd4dc2"
    sha256                               arm64_monterey: "952db556ed242fee2bdf618610f88b68f24e4c6d261a22164be8f7ef89cf397f"
    sha256                               sonoma:         "81c0cd1760c85d0b8c60b601068bf41b855ce777a493fd18d4f4413648ae1ed5"
    sha256                               ventura:        "27199e6c95bc484a8e44aac5e77855a7f1625cebcf66b61693c5daf086497c5c"
    sha256                               monterey:       "e7f6519520f7bca305081c053adf783c3110c81e22b09991d6c76c63a3037313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91cebcfd1e7048142529c11989ae759d2f44474019d0082d00cf0ae5ea229b4b"
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