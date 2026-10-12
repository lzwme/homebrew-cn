class Libmsquic < Formula
  desc "Cross-platform, C implementation of the IETF QUIC protocol"
  homepage "https://github.com/microsoft/msquic"
  url "https://ghfast.top/https://github.com/microsoft/msquic/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "206e4604eb7ffbc496eb4df804afaaba4814c2bbfdb18fdb142172301b74c8c0"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6083ca2dea5b2b7fc8568c497f6922522929bfd7d75917bd33af405ea21e28e7"
    sha256 cellar: :any, arm64_tahoe:       "b818584bd4454b22a09fefc8b1cda228c860ee635826a1c0844d87fe548859fe"
    sha256 cellar: :any, arm64_sequoia:     "1749310e25c9bee14d40f01adb81cd339e5e547f71021be2c5a8703fe842cc5b"
    sha256 cellar: :any, arm64_linux:       "e4314bd365aa6c8b360e5dd581a2ba048ac5fc8a8fe9caa47ae7796ba95ef296"
    sha256 cellar: :any, x86_64_linux:      "ed9e298d1769f1bdf2ed73a17144995539055e8282ae7eaadf66f352e7a7dca7"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"

  deny_network_access!

  def install
    args = %w[
      -DQUIC_BUILD_PERF=OFF
      -DQUIC_BUILD_TOOLS=OFF
      -DQUIC_TLS_LIB=openssl
      -DQUIC_USE_EXTERNAL_OPENSSL=ON
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
    system ENV.cxx, "-std=c++17", example, "-I#{include}", "-L#{lib}", "-lmsquic", "-o", "test"
    assert_equal "MsQuicOpen2 succeeded", shell_output("./test").strip
  end
end