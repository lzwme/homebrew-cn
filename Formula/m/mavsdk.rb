class Mavsdk < Formula
  desc "API and library for MAVLink compatible systems written in C++17"
  homepage "https://mavsdk.mavlink.io/main/en/index.html"
  url "https://github.com/mavlink/MAVSDK.git",
      tag:      "v3.14.0",
      revision: "7cbd8e5af40892bbb62f6025ee3ff14a70765829"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "edb6d86b154e1bca5a93bd122a0447ac5ad517d0ff12e5efaeff44e40e44a816"
    sha256               arm64_sequoia: "92b14108d9cffd84e10455bb4158bcc897796f8a4f69510a12e9833576eba065"
    sha256               arm64_sonoma:  "48bd81ed09f69599383a34c5f2ce0ce4454995d5e0ed46e5a3e670c3b00c02f0"
    sha256 cellar: :any, sonoma:        "dc6aaea275b9cdf997cfb20c7b1dc74df5484b4c144def04d723b65b13b83ead"
    sha256               arm64_linux:   "c0ba43579483e7724e8fd6638f9456bbc1ddf34693730cb3a2fd72f7039abe68"
    sha256               x86_64_linux:  "bd8e0a1b77fd2375005d10cc182ccaf51eea4009c9988365f6f9506a1e448ebd"
  end

  depends_on "cmake" => :build
  depends_on "python@3.14" => :build
  depends_on "rust" => :build
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

  # Git is required to fetch submodules
  resource "mavlink" do
    url "https://github.com/mavlink/mavlink.git",
        revision: "d6a7eeaf43319ce6da19a1973ca40180a4210643"
    version "d6a7eeaf43319ce6da19a1973ca40180a4210643"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/mavlink/MAVSDK/refs/tags/v#{LATEST_VERSION}/third_party/CMakeLists.txt"
      regex(/MAVLINK_HASH.*(\h{40})/i)
    end
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    # Fix version being reported as `v#{version}-dirty`
    inreplace "CMakeLists.txt", "OUTPUT_VARIABLE VERSION_STR", "OUTPUT_VARIABLE VERSION_STR_IGNORED"

    # Regenerate files to support newer protobuf
    system "tools/generate_from_protos.sh"

    # `mavlink` repo and hash info moved to `third_party/CMakeLists.txt` only for SUPERBUILD,
    # so we have to manage the hash manually, but then it is better to keep it as a resource.
    (buildpath/"third_party/mavlink").install resource("mavlink")

    %w[mavlink picosha2 libevents libmavlike].each do |dep|
      system "cmake", "-S", "third_party/#{dep}", "-B", "build_#{dep}",
                      "-DMAVLINK_DIALECT=ardupilotmega",
                      *std_cmake_args(install_prefix: libexec)
      system "cmake", "--build", "build_#{dep}"
      system "cmake", "--install", "build_#{dep}"
    end

    # Install MAVLink message definitions manually
    messages_files = "{minimal,standard,common,ardupilotmega}.xml"
    messages_dir = Dir["#{buildpath}/third_party/mavlink/message_definitions/v1.0/#{messages_files}"]
    (libexec/"include/mavlink/message_definitions/v1.0").install messages_dir

    # Source build adapted from
    # https://mavsdk.mavlink.io/main/en/cpp/guide/build.html
    args = %W[
      -DSUPERBUILD=OFF
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_MAVSDK_SERVER=ON
      -DBUILD_TESTS=OFF
      -DVERSION_STR=v#{version}-#{tap.user}
      -DCMAKE_PREFIX_PATH=#{libexec}
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DDEPS_INSTALL_PATH=#{libexec}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Force use of Clang on Mojave
    ENV.clang if OS.mac?

    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <mavsdk/mavsdk.h>
      using namespace mavsdk;
      int main() {
          Mavsdk mavsdk{Mavsdk::Configuration{ComponentType::GroundStation}};
          std::cout << mavsdk.version() << std::endl;
          return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", testpath/"test.cpp", "-o", "test",
                    "-I#{include}", "-L#{lib}", "-lmavsdk"
    assert_match "v#{version}-#{tap.user}", shell_output("./test").chomp

    assert_equal "Usage: #{bin}/mavsdk_server [Options] [Connection URL]",
                 shell_output("#{bin}/mavsdk_server --help").split("\n").first
  end
end