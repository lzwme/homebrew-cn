class Libmsquic < Formula
  desc "Cross-platform, C implementation of the IETF QUIC protocol"
  homepage "https://github.com/microsoft/msquic"
  url "https://github.com/microsoft/msquic.git",
      tag:      "v2.6.2",
      revision: "819ab74f851ee168504cbc392ec32e7bed1d82e9"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1e76486cb83c4f14cfba35d3b63f82e46a21387145092b88a29a186e9ce22733"
    sha256 cellar: :any, arm64_tahoe:       "d9b361c3709c4bac0a01623c35b62e45d1c4ceefa2a16a65af084f95e4131b7f"
    sha256 cellar: :any, arm64_sequoia:     "c7d7fbdaec216ced0ed5b9b7b58d3d6b251e96dc4d666409e3fb211cf8c3bf55"
    sha256 cellar: :any, arm64_linux:       "0e2b620b95427a1bb33082dbbdac1908a56261b28bce0625f255c6838b8a4c05"
    sha256 cellar: :any, x86_64_linux:      "e56358a568a866926c75f12bb9e63a354733e3ed90ea797301f57e958424ea5e"
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