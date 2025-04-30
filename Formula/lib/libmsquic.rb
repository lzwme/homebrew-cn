class Libmsquic < Formula
  desc "Cross-platform, C implementation of the IETF QUIC protocol"
  homepage "https:github.commicrosoftmsquic"
  url "https:github.commicrosoftmsquic.git",
      tag:      "v2.4.10",
      revision: "0c3596a214de2b085688628509c75295be67f2d5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "324ed4423db3ac88eb60ca4d1029cd73253395c214a7ea696330267e46abde5b"
    sha256 cellar: :any,                 arm64_sonoma:  "9b63b6a9d8390d27f4cafcf6e8ebd3c73755163c31e83b3d504e13b247f7c624"
    sha256 cellar: :any,                 arm64_ventura: "a1bfc24221f3f53625dbcde83a224d58fb09fe1a51d3cdfd005c159ef6fac56e"
    sha256 cellar: :any,                 sonoma:        "c32dbf35e019647247cc21353402bd928bd4bd3ea85feb436776c05c4c11ce08"
    sha256 cellar: :any,                 ventura:       "406084ad858c3a4da839fdfc919ef8a0310a431332079661f4d32b3aa7b8f535"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fab60bf592e876e95ef8110e2e14b0ded992da60324cbb8fd154b8491a38392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b2ba210188e21b19ee0bce5d1a409b78b8b678b2834a62e85ff3614e3138584"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    args = %w[
      -DQUIC_TLS=openssl3
      -DQUIC_USE_SYSTEM_LIBCRYPTO=true
      -DQUIC_BUILD_PERF=OFF
      -DQUIC_BUILD_TOOLS=OFF
      -DQUIC_BUILD_TESTS=OFF
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    example = testpath"example.cpp"
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
    assert_equal "MsQuicOpen2 succeeded", shell_output(".test").strip
  end
end