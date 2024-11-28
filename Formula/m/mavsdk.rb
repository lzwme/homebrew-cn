class Mavsdk < Formula
  desc "API and library for MAVLink compatible systems written in C++17"
  homepage "https:mavsdk.mavlink.io"
  url "https:github.commavlinkMAVSDK.git",
      tag:      "v2.12.12",
      revision: "a82b29756dcc4ea44c8c2c18f116b2cbdf4142c3"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6f81895874e5573a901011927889ec705ec4ab1172d88a9b9b811c5f7708634e"
    sha256 cellar: :any,                 arm64_sonoma:  "bbb0d5177410f0db0b18e84298d002551cda1d4e81466c5502834e93333325c0"
    sha256 cellar: :any,                 arm64_ventura: "4fd2439d351162478e6625efb39037c6c04908d106bc8f46159da4e1bf6c390d"
    sha256 cellar: :any,                 sonoma:        "27c9833b28759f21a5525a8fce87f558f5beb657b649a150213d3c93fa04fb7c"
    sha256 cellar: :any,                 ventura:       "be5ace487484082f83dd0d5601f8bba19fbbd68649814d50aceee3de081e3ed5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "870e273549285d7479f11b21d710e323db4c338819c0a37629f05f3167aaa2d0"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build
  depends_on "abseil"
  depends_on "c-ares"
  depends_on "curl"
  depends_on "grpc"
  depends_on "jsoncpp"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "re2"
  depends_on "tinyxml2"
  depends_on "xz"

  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::__status(std::__1::__fs::filesystem::path const&, std::__1::error_code*)"
    EOS
  end

  # ver={version} && \
  # curl -s https:raw.githubusercontent.commavlinkMAVSDKv$verthird_partymavlinkCMakeLists.txt && \
  # | grep 'MAVLINK_GIT_HASH'
  resource "mavlink" do
    url "https:github.commavlinkmavlink.git",
        revision: "f1d42e2774cae767a1c0651b0f95e3286c587257"
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    # Fix version being reported as `v#{version}-dirty`
    inreplace "CMakeLists.txt", "OUTPUT_VARIABLE VERSION_STR", "OUTPUT_VARIABLE VERSION_STR_IGNORED"

    # Regenerate files to support newer protobuf
    system "toolsgenerate_from_protos.sh"

    resource("mavlink").stage do
      system "cmake", "-S", ".", "-B", "build",
                      "-DPython_EXECUTABLE=#{which("python3.12")}",
                      *std_cmake_args(install_prefix: libexec)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    # Source build adapted from
    # https:mavsdk.mavlink.iodevelopencontributingbuild.html
    system "cmake", "-S", ".", "-B", "build",
                    "-DSUPERBUILD=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DBUILD_MAVSDK_SERVER=ON",
                    "-DBUILD_TESTS=OFF",
                    "-DVERSION_STR=v#{version}-#{tap.user}",
                    "-DCMAKE_PREFIX_PATH=#{libexec}",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Force use of Clang on Mojave
    ENV.clang if OS.mac?

    (testpath"test.cpp").write <<~CPP
      #include <iostream>
      #include <mavsdkmavsdk.h>
      using namespace mavsdk;
      int main() {
          Mavsdk mavsdk{Mavsdk::Configuration{Mavsdk::ComponentType::GroundStation}};
          std::cout << mavsdk.version() << std::endl;
          return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", testpath"test.cpp", "-o", "test",
                    "-I#{include}", "-L#{lib}", "-lmavsdk"
    assert_match "v#{version}-#{tap.user}", shell_output(".test").chomp

    assert_equal "Usage: #{bin}mavsdk_server [Options] [Connection URL]",
                 shell_output("#{bin}mavsdk_server --help").split("\n").first
  end
end