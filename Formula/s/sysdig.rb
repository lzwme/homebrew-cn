class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https:sysdig.com"
  license "Apache-2.0"
  revision 4

  stable do
    url "https:github.comdraiossysdigarchiverefstags0.38.1.tar.gz"
    sha256 "68085ea118a4209dbde8f1b75584f9f84610b5856e507ffb0703d8add6331132"

    # Update to value of FALCOSECURITY_LIBS_VERSION with
    # VERSION=#{version} && curl -fsSL https:raw.githubusercontent.comdraiossysdig$VERSIONcmakemodulesfalcosecurity-libs.cmake | grep -o 'set(FALCOSECURITY_LIBS_VERSION "[0-9.]*")' | awk -F'"' '{print $2}'
    resource "falcosecurity-libs" do
      url "https:github.comfalcosecuritylibsarchiverefstags0.17.2.tar.gz"
      sha256 "5c4f0c987272b7d5236f6ab2bbe3906ffdaf76b59817b63cf90cc8c387ab5b15"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "be7bb783db164471d11374a27dfba5fd1baf8329d8d079689292c35f0c1ad58c"
    sha256                               arm64_sonoma:  "db78f5aee99ebf9ee9b394fe840a9f16cb05affc800b71624c70eca39f8e6dfa"
    sha256                               arm64_ventura: "aa0380e819f067e1aa67bb42cfe3f23a05801ae908546fe1e786b9f78e180424"
    sha256                               sonoma:        "44324e83ef7620bb8c5f7683b2e85b01489fb4b8cb74dddd3850a65ed1a45564"
    sha256                               ventura:       "408586526bdf80edb128477806e07bcb4c1a51f6266c85717084217f0a400d4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40112c86d484523ee3f11130c9ff91fe3bb53fd7697065d56f05c46bbe2d83de"
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
  depends_on "jsoncpp"
  depends_on "luajit"
  depends_on "ncurses" # for `newterm` function
  depends_on "re2"
  depends_on "tbb"
  depends_on "uthash"
  depends_on "yaml-cpp"

  uses_from_macos "curl"
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
      -DCREATE_TEST_TARGETS=OFF
      -DBUILD_LIBSCAP_EXAMPLES=OFF
      -DDIR_ETC=#{etc}
      -DFALCOSECURITY_LIBS_SOURCE_DIR=#{buildpath}falcosecurity-libs
    ]

    # `USE_BUNDLED_*=OFF` flags are implied by `USE_BUNDLED_DEPS=OFF`, but let's be explicit.
    %w[CARES JSONCPP LUAJIT OPENSSL RE2 TBB VALIJSON CURL NCURSES ZLIB B64 GRPC JQ PROTOBUF].each do |dep|
      args << "-DUSE_BUNDLED_#{dep}=OFF"
    end

    args += ["-DBUILD_DRIVER=OFF", "-DBUILD_LIBSCAP_MODERN_BPF=OFF"] if OS.linux?

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