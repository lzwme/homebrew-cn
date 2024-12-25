class Mavsdk < Formula
  desc "API and library for MAVLink compatible systems written in C++17"
  homepage "https:mavsdk.mavlink.io"
  url "https:github.commavlinkMAVSDK.git",
      tag:      "v2.14.1",
      revision: "2b98c53af5f5c0ad5686816e85b47090569245a4"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5ffbeedba126e8f0973ffd8147d74c98b898bf6915ca1ae1ec37101a8a39d572"
    sha256 cellar: :any,                 arm64_sonoma:  "f97d98d1de65c499d2c8de5ab46d7ac699ff0352a18abaa6f512f95c9626eb1b"
    sha256 cellar: :any,                 arm64_ventura: "069cba7871409ed9fc5e8eb87ba49d7e9939cd421bbb1b26a440fc0b7b7238b5"
    sha256 cellar: :any,                 sonoma:        "b709603b92c5b1e1e0c7715493f0c02cbbfd940dbe3fa247a7ff3d1a673a91c0"
    sha256 cellar: :any,                 ventura:       "971bfb3cc05e45b8aa353b5e61995827a88061c274a6205ca31bd05b57a1b2ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57d48fb109852d2f1231ebdb2aa260f46fd25d59860186245257b0af5abb38b5"
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
    cause <<~EOS
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