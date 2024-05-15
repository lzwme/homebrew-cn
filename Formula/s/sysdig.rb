class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https:sysdig.com"
  license "Apache-2.0"

  stable do
    url "https:github.comdraiossysdigarchiverefstags0.37.1.tar.gz"
    sha256 "b01c4d097a5f87b7380612fc5897490627ccbf1a5c5cbe8aa185e7fd459daa9b"

    # Update to value of FALCOSECURITY_LIBS_VERSION with
    # VERSION=#{version} && curl -fsSL https:raw.githubusercontent.comdraiossysdig$VERSIONcmakemodulesfalcosecurity-libs.cmake | grep -o 'set(FALCOSECURITY_LIBS_VERSION "[0-9.]*")' | awk -F'"' '{print $2}'
    resource "falcosecurity-libs" do
      url "https:github.comfalcosecuritylibsarchiverefstags0.16.0.tar.gz"
      sha256 "5b13d6160bc09ea9b56d70951b68db0aaad45bd0171690eddc08c8028e1b7928"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "3280d421289871e61de86045c56907c3240b30fa93dc43d1734680ef8a7e232c"
    sha256                               arm64_ventura:  "997dcca4ff9a5be37ec33a1bdc83279ab8b043067ec5f7410a4d3f7cbf337562"
    sha256                               arm64_monterey: "d8fa74ed3cd50a2503462445fb6e4f6289fef9bc18f53a0ae9234173e49f3a7e"
    sha256                               sonoma:         "efd14a2d5d39d719647e633fa2f2f4e538c8050470a4df4cfce732b87be6820e"
    sha256                               ventura:        "d594a71c3cf08ff02e9b973b246c605a50cee74dfc7116742fd758fa2fcdc75a"
    sha256                               monterey:       "8f9d5db659eb45ca533aaa199d15fa68b3d4570950a01aefad12ff2e4a6636b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7c1d5b3a20bdb6dd1e379e9d765a6363d052f3e507d7b035d13a2e8678e09ed"
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