class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://sysdig.com/"
  license "Apache-2.0"
  revision 1

  stable do
    url "https://ghproxy.com/https://github.com/draios/sysdig/archive/refs/tags/0.31.4.tar.gz"
    sha256 "b8f43326506f85e99a3455f51b75ee79bf4db9dc12908ef43af672166274a795"

    # Update to value of FALCOSECURITY_LIBS_VERSION found in
    # https://github.com/draios/sysdig/blob/#{version}/cmake/modules/falcosecurity-libs.cmake
    resource "falcosecurity-libs" do
      url "https://ghproxy.com/https://github.com/falcosecurity/libs/archive/refs/tags/0.10.5.tar.gz"
      sha256 "2a4b37c08bec4ba81326314831f341385aff267062e8d4483437958689662936"

      # Fix 'file INSTALL cannot make directory "/sysdig/userspace/libscap"'.
      # Reported upstream at https://github.com/falcosecurity/libs/issues/995.
      patch :DATA
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_ventura:  "fc0b6d775216a41f48f90bed342bd0d8d685f6bafda7af0c679bba7fef7750a4"
    sha256                               arm64_monterey: "aff4d26ac29272328b59b16a788caf5ac441f3c19de956e56196b84d68d1e5b0"
    sha256                               arm64_big_sur:  "ab88cc179ffa31ee7ed62f157f22c8c0029aa7251f1be8747cd6ad227156010f"
    sha256                               ventura:        "85b85a9c3f18fea4cbe8b20f63e6df9d4560273601cbda1907fee54da793d0f1"
    sha256                               monterey:       "1b8ba6006c8ee808978ab0b2c259711e7f95de54cb6cd82e31c214e84d1e7452"
    sha256                               big_sur:        "49f3c8b2ee5849bd97f9f8a3ddb9ca61aa4878d23e3505484458138b247d8d0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35e7aa08c24f5c063fe8268ed2ca1cb3cac04d47e42a36310e6d8e8e89da58dc"
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

__END__
--- a/cmake/modules/libscap.cmake
+++ b/cmake/modules/libscap.cmake
@@ -49,6 +49,9 @@ if(BUILD_LIBSCAP_MODERN_BPF)
        "${PROJECT_BINARY_DIR}/libpman/libpman.a"
 endif()
 )
+
+include(GNUInstallDirs)
+
 install(FILES ${LIBSCAP_LIBS} DESTINATION "${CMAKE_INSTALL_LIBDIR}/${LIBS_PACKAGE_NAME}"
                        COMPONENT "scap" OPTIONAL)
 install(DIRECTORY "${LIBSCAP_INCLUDE_DIR}" DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${LIBS_PACKAGE_NAME}/userspace"