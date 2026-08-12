class Libmsquic < Formula
  desc "Cross-platform, C implementation of the IETF QUIC protocol"
  homepage "https://github.com/microsoft/msquic"
  url "https://github.com/microsoft/msquic.git",
      tag:      "v2.5.10",
      revision: "9ff06b71fd4b4d5258361598ada5b24cbc1beb20"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e7a3cb18a92b0ab0f6e2ffc8e9978b7ee5165e08e05ce4ec3720eb973b07813c"
    sha256 cellar: :any, arm64_sequoia: "f6705fbc161ea9584f5347da0d01d7c0ae6d5df6a07ca458e2c3bdc44dccb2d3"
    sha256 cellar: :any, arm64_sonoma:  "9fa81583eb14b1500730d39c080fc56355f3b9365ddd88f469c9cd4471bd4448"
    sha256 cellar: :any, sonoma:        "dc7a9dde9bfce5c3f316ec18db196b2a64e2b52276361865180ebfec3e0dad00"
    sha256 cellar: :any, arm64_linux:   "4514b8226a4d61e96267dc1f130a86777b27bac423288355ba7de6733ba3e048"
    sha256 cellar: :any, x86_64_linux:  "9bb80cb78dee9ff7d5c05a8f3d9d52ac9ac7b54fce11123cb7bb1a569a0fce19"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    args = %w[
      -DQUIC_USE_SYSTEM_LIBCRYPTO=true
      -DQUIC_BUILD_PERF=OFF
      -DQUIC_BUILD_TOOLS=OFF
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    example = testpath/"example.cpp"
    example.write <<~CPP
      #include <iostream>
      #include <msquic.h>

      int main()
      {
          const QUIC_API_TABLE * ptr = {nullptr};
          if (auto status = MsQuicOpen2(&ptr); QUIC_FAILED(status))
          {
              std::cout << "MsQuicOpen2 failed: " << status << std::endl;
              return 1;
          }

          std::cout << "MsQuicOpen2 succeeded";
          MsQuicClose(ptr);
          return 0;
      }
    CPP
    system ENV.cxx, example, "-I#{include}", "-L#{lib}", "-lmsquic", "-o", "test"
    assert_equal "MsQuicOpen2 succeeded", shell_output("./test").strip
  end
end