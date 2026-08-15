class Serialize < Formula
  desc "Single-header bitpacking serializer for C++ aimed at game networking"
  homepage "https://github.com/mas-bandwidth/serialize"
  url "https://ghfast.top/https://github.com/mas-bandwidth/serialize/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "7fcac87ed75b1f2f4de2df29717e3ec3a575e35ba3e6fab31dacb6f84aede9fc"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d13fca7e1c87adf1780e7f6639a2f8315dd76e5f4e880e8656c20e93975ad1e0"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DSERIALIZE_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <serialize.h>
      int main()
      {
          uint8_t buffer[64];
          memset( buffer, 0, sizeof( buffer ) );
          serialize::WriteStream writer( buffer, 64 );
          uint32_t written = 12345;
          writer.SerializeBits( written, 14 );
          writer.Flush();
          serialize::ReadStream reader( buffer, writer.GetBytesProcessed() );
          uint32_t value = 0;
          reader.SerializeBits( value, 14 );
          return value == 12345 ? 0 : 1;
      }
    CPP
    system ENV.cxx, "test.cpp", "-I#{include}", "-o", "test"
    system "./test"
  end
end