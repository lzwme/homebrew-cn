class Mavsdk < Formula
  desc "API and library for MAVLink compatible systems written in C++17"
  homepage "https:mavsdk.mavlink.io"
  url "https:github.commavlinkMAVSDK.git",
      tag:      "v2.7.0",
      revision: "324b64543d5ec1ad3d480b6d8a13d6cdc67ee68b"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2333756888663d51ed8e8cb92595a8fad26f22c4bdfad46c63fc045ed3e0b916"
    sha256 cellar: :any,                 arm64_ventura:  "af964b4ede650ce798960761941a90b1b268f74ac282d563b3a0ed81d1e87523"
    sha256 cellar: :any,                 arm64_monterey: "d5202b80c6e9e043be51d360b83a6afc80d631e3adf5b9e2a836ca22829d55b9"
    sha256 cellar: :any,                 sonoma:         "bfee10df17b0eb9f1bba928d39c48ff4024d2b9f5e98b6b9fe2b38e95441c88f"
    sha256 cellar: :any,                 ventura:        "20ec2711a6883563e4396ca23ff2169a1724f87037d5f66d4a7879588b1017e4"
    sha256 cellar: :any,                 monterey:       "b300f90c084f70fbfca4c842ca8029020d3f1c41ff466a832fcc86c51f97d87f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5274eb8ba20111abd0c2bdcabc75144b1252eb1e3bd92f88a99dc9a5d4f7e088"
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

  fails_with gcc: "5"

  # MAVLINK_GIT_HASH in https:github.commavlinkMAVSDKblobv#{version}third_partymavlinkCMakeLists.txt
  resource "mavlink" do
    url "https:github.commavlinkmavlink.git",
        revision: "9840105a275db1f48f9711d0fb861e8bf77a2245"
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

    (testpath"test.cpp").write <<~EOS
      #include <iostream>
      #include <mavsdkmavsdk.h>
      using namespace mavsdk;
      int main() {
          Mavsdk mavsdk{Mavsdk::Configuration{Mavsdk::ComponentType::GroundStation}};
          std::cout << mavsdk.version() << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", testpath"test.cpp", "-o", "test",
                    "-I#{include}", "-L#{lib}", "-lmavsdk"
    assert_match "v#{version}-#{tap.user}", shell_output(".test").chomp

    assert_equal "Usage: #{bin}mavsdk_server [Options] [Connection URL]",
                 shell_output("#{bin}mavsdk_server --help").split("\n").first
  end
end