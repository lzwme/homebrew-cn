class Mavsdk < Formula
  desc "API and library for MAVLink compatible systems written in C++17"
  homepage "https:mavsdk.mavlink.io"
  url "https:github.commavlinkMAVSDK.git",
      tag:      "v3.5.0",
      revision: "55fbea8ef72860c9f9feab2f44b2bb364f0c0e81"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sequoia: "53eedf351ce32698acddb883c3b02e768e7c0ca91b1337ccf9d084cde155294d"
    sha256                               arm64_sonoma:  "247468a6878bf8cb3bc2b24d46934336127708616d37027fb188559296115112"
    sha256                               arm64_ventura: "8ffec498eb95b1654ea1bde0eee1c4fc62a29d44831930587bb2ee63886110d4"
    sha256 cellar: :any,                 sonoma:        "96fe64c9dafcaad4f4cdbe2dcbd0e33dafbab39eaa2ecd31de2915721733229a"
    sha256 cellar: :any,                 ventura:       "e93a2254de44039ff504f2af9008541b363642c3b89873de99736dc282728031"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d59bfb110c6c26448c9dc9deaf130cd7bc1812e1086bf7cab0bd83b5e0f3e95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10be4fe79adca8ec4efd70be3f20cb767580887361082fe5ce244eb84c8e4cff"
  end

  depends_on "cmake" => :build
  depends_on "python@3.13" => :build
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
  # curl -s https:raw.githubusercontent.commavlinkMAVSDKv$verthird_partymavlinkCMakeLists.txt \
  # | grep 'MAVLINK_GIT_HASH'
  resource "mavlink" do
    url "https:github.commavlinkmavlink.git",
        revision: "5e3a42b8f3f53038f2779f9f69bd64767b913bb8"
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    # Fix version being reported as `v#{version}-dirty`
    inreplace "CMakeLists.txt", "OUTPUT_VARIABLE VERSION_STR", "OUTPUT_VARIABLE VERSION_STR_IGNORED"

    # Regenerate files to support newer protobuf
    system "toolsgenerate_from_protos.sh"

    resource("mavlink").stage do
      system "cmake", "-S", ".", "-B", "build",
                      "-DPython_EXECUTABLE=#{which("python3.13")}",
                      *std_cmake_args(install_prefix: libexec)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    # Source build adapted from
    # https:mavsdk.mavlink.iodevelopencontributingbuild.html
    args = %W[
      -DSUPERBUILD=OFF
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_MAVSDK_SERVER=ON
      -DBUILD_TESTS=OFF
      -DVERSION_STR=v#{version}-#{tap.user}
      -DCMAKE_PREFIX_PATH=#{libexec}
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
          Mavsdk mavsdk{Mavsdk::Configuration{ComponentType::GroundStation}};
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