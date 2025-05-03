class Mavsdk < Formula
  desc "API and library for MAVLink compatible systems written in C++17"
  homepage "https:mavsdk.mavlink.io"
  url "https:github.commavlinkMAVSDK.git",
      tag:      "v3.2.0",
      revision: "c4a070f974b3d91375f096095d952cb8ef416849"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sequoia: "1cecb7183760351aae4941eb066827ccb6d5347de3bf49eae96a00d36c8c38f1"
    sha256                               arm64_sonoma:  "a9b97564565b4d1811c831565422b0750de404427c6b9549ce3deff64f182a8f"
    sha256                               arm64_ventura: "8d205829ab9dffd2ae18cd97a15246d3a29583e3f67686a157a49270c4aa0410"
    sha256 cellar: :any,                 sonoma:        "ad18deffbb8f4b106a7c86d7c380a26ce7e01178b38818a2907cf6d0cbf5f5ad"
    sha256 cellar: :any,                 ventura:       "e4a789285d69e94df85209b06ab887bb94d3d168a0c77adda1cd78b0d73d8517"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c28b81f2a02c8d1a62b6d645023540f427c9a9a8340302bc108920b5215e5751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "820463d651ceb5f1d70fa3918005d2a0b1df385b340ef72bb9aa49974d529fb8"
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