class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://sysdig.com/"
  license "Apache-2.0"

  stable do
    url "https://ghproxy.com/https://github.com/draios/sysdig/archive/refs/tags/0.31.5.tar.gz"
    sha256 "9af98cae7c38273f7429ba0df628c9745bd92c949f444e180b9dd800af14c6dd"

    # Update to value of FALCOSECURITY_LIBS_VERSION found in
    # https://github.com/draios/sysdig/blob/#{version}/cmake/modules/falcosecurity-libs.cmake
    resource "falcosecurity-libs" do
      url "https://ghproxy.com/https://github.com/falcosecurity/libs/archive/refs/tags/0.10.5.tar.gz"
      sha256 "2a4b37c08bec4ba81326314831f341385aff267062e8d4483437958689662936"

      # Fix 'file INSTALL cannot make directory "/sysdig/userspace/libscap"'.
      # Remove when `falcosecurity-libs` is upgraded to 0.11.0 or newer.
      patch do
        url "https://github.com/falcosecurity/libs/commit/73020ac4fdd1ba84b53f431e1c069049828480e9.patch?full_index=1"
        sha256 "97fde5e4aa8e20e91ffaaca4020b7a38751d1ad95d69db02bf10c82588c6595b"
      end
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_ventura:  "b1d9607da0696d73a6c9a837e3ec917283ad4817a2957e8e0ddd9eec5226ad67"
    sha256                               arm64_monterey: "8b3ae57dc73bad26a4e96dd2a1519d6aab725124ade13684da58560ab434036e"
    sha256                               arm64_big_sur:  "791dd62459dc22cb52ad8a4f18066e0cf0ab1dad2754583b6b5f494159904257"
    sha256                               ventura:        "9143dcbe2bd74dc85b7f1ef20095be10e956cce520e8106b03e7dabcb3c58ba4"
    sha256                               monterey:       "a2f7db87af836858cb7ab425330e621d54a21ce2e8a8d64e71a96b09e8c73fa2"
    sha256                               big_sur:        "d940489a00a0577799285fbcd98e5c332e0e7a718ef7aefe4bf2af23315829c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d758951dd5c1602a1020f517294b83bf6a372523d8b1174e3be903d1ae74b526"
  end

  head do
    url "https://github.com/draios/sysdig.git", branch: "dev"

    resource "falcosecurity-libs" do
      url "https://github.com/falcosecurity/libs.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "c-ares"
  depends_on "jsoncpp"
  depends_on "luajit"
  depends_on "openssl@1.1"
  depends_on "re2"
  depends_on "tbb"
  depends_on "valijson"
  depends_on "yaml-cpp"

  uses_from_macos "curl"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libb64" => :build
    depends_on "elfutils"
    depends_on "grpc"
    depends_on "jq"
    depends_on "protobuf"
  end

  fails_with gcc: "5" # C++17

  # More info on https://gist.github.com/juniorz/9986999
  resource "homebrew-sample_file" do
    url "https://ghproxy.com/https://gist.githubusercontent.com/juniorz/9986999/raw/a3556d7e93fa890a157a33f4233efaf8f5e01a6f/sample.scap"
    sha256 "efe287e651a3deea5e87418d39e0fe1e9dc55c6886af4e952468cd64182ee7ef"
  end

  def install
    (buildpath/"falcosecurity-libs").install resource("falcosecurity-libs")

    # FIXME: Workaround Apple ARM loader error due to packing.
    # ld: warning: pointer not aligned at address 0x10017E21D
    #   (_g_event_info + 527453 from ../../libscap/libscap.a(event_table.c.o))
    # ld: unaligned pointer(s) for architecture arm64
    inreplace "falcosecurity-libs/driver/ppm_events_public.h", " __attribute__((packed))", "" if Hardware::CPU.arm?

    # Override hardcoded C++ standard settings.
    inreplace %w[CMakeLists.txt falcosecurity-libs/cmake/modules/CompilerFlags.cmake],
              /set\(CMAKE_CXX_FLAGS "(.*) -std=c\+\+0x"\)/,
              'set(CMAKE_CXX_FLAGS "\\1")'

    # Keep C++ standard in sync with `abseil.rb`.
    args = %W[
      -DSYSDIG_VERSION=#{version}
      -DUSE_BUNDLED_DEPS=OFF
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