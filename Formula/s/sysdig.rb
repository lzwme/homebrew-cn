class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://sysdig.com/"
  license "Apache-2.0"

  stable do
    url "https://ghproxy.com/https://github.com/draios/sysdig/archive/refs/tags/0.34.0.tar.gz"
    sha256 "6bbec26ebc4f6ef2866b1c533661b69d399fd8d7057235a94301b31d5b154f1b"

    # Update to value of FALCOSECURITY_LIBS_VERSION found in
    # https://github.com/draios/sysdig/blob/#{version}/cmake/modules/falcosecurity-libs.cmake
    resource "falcosecurity-libs" do
      url "https://ghproxy.com/https://github.com/falcosecurity/libs/archive/refs/tags/0.13.1.tar.gz"
      sha256 "2be42a27be3ffe6bd7e53eaa5d8358cab05a0dca821819c6e9059e51b9786219"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "e76ffdcc36d9a89f451d92692b393fd80392f6dec22f43d7d0625bfcdbcbdd6a"
    sha256                               arm64_ventura:  "785be4df009479a82d615d5c0bae0b56f7b15a2f648cee64d83b728152dcb2bf"
    sha256                               arm64_monterey: "74908e864dae3c315fa81e70b6909b2d68b2074c90acb27b4502079d5cbb3dd0"
    sha256                               sonoma:         "eb79e163a450e7279cd4ee74de3605adeb5fa1903cc907b187731660393e0aaf"
    sha256                               ventura:        "96a6c5b77a7b740b3cf559482e5df3a40ee164fd09e9a9919acdf96bd28bea71"
    sha256                               monterey:       "14d549570f9f9860ae399cf1c0cd5dd0adf76d5a145e981bcb7386726f543015"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "280be9725a5a79c4a701bb2a8bca9ebb917c3c334675675fa2488af574a4f1ef"
  end

  head do
    url "https://github.com/draios/sysdig.git", branch: "dev"

    resource "falcosecurity-libs" do
      url "https://github.com/falcosecurity/libs.git", branch: "master"
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
    depends_on "grpc@1.54"
    depends_on "jq"
    depends_on "openssl@3"
    depends_on "protobuf@21"
    depends_on "zstd"
  end

  fails_with gcc: "5" # C++17

  # More info on https://gist.github.com/juniorz/9986999
  resource "homebrew-sample_file" do
    url "https://ghproxy.com/https://gist.githubusercontent.com/juniorz/9986999/raw/a3556d7e93fa890a157a33f4233efaf8f5e01a6f/sample.scap"
    sha256 "efe287e651a3deea5e87418d39e0fe1e9dc55c6886af4e952468cd64182ee7ef"
  end

  def install
    (buildpath/"falcosecurity-libs").install resource("falcosecurity-libs")

    # fix `libzstd.so.1: error adding symbols: DSO missing from command line` error
    # https://stackoverflow.com/a/55086637
    ENV.append "LDFLAGS", "-Wl,--copy-dt-needed-entries" if OS.linux?

    # Keep C++ standard in sync with `abseil.rb`.
    args = %W[
      -DSYSDIG_VERSION=#{version}
      -DUSE_BUNDLED_DEPS=OFF
      -DUSE_BUNDLED_TINYDIR=ON
      -DCREATE_TEST_TARGETS=OFF
      -DBUILD_LIBSCAP_EXAMPLES=OFF
      -DDIR_ETC=#{etc}
      -DFALCOSECURITY_LIBS_SOURCE_DIR=#{buildpath}/falcosecurity-libs
      -DCMAKE_CXX_FLAGS=-std=c++17
    ]

    # `USE_BUNDLED_*=OFF` flags are implied by `USE_BUNDLED_DEPS=OFF`, but let's be explicit.
    %w[CARES JSONCPP LUAJIT OPENSSL RE2 TBB VALIJSON CURL NCURSES ZLIB B64 GRPC JQ PROTOBUF].each do |dep|
      args << "-DUSE_BUNDLED_#{dep}=OFF"
    end

    args << "-DBUILD_DRIVER=OFF" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (pkgshare/"demos").install resource("homebrew-sample_file").files("sample.scap")
  end

  test do
    output = shell_output("#{bin}/sysdig -r #{pkgshare}/demos/sample.scap")
    assert_match "/tmp/sysdig/sample", output
  end
end