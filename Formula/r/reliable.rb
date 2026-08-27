class Reliable < Formula
  desc "Simple packet acknowledgement system for UDP-based protocols"
  homepage "https://github.com/mas-bandwidth/reliable"
  url "https://ghfast.top/https://github.com/mas-bandwidth/reliable/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "31d46ad5ab6549f1e933984332d33b54387482f1874b03bfda0ef982db4d448e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "794c6fcb23e9c01b3100d409e7d25d4e48b37e07ec684587a34fa1ced3955dd0"
    sha256 cellar: :any, arm64_sequoia: "6fc72f18fbad587de4af742a87777a7c62a0ba0519def69bdbda71fb532d40bc"
    sha256 cellar: :any, arm64_sonoma:  "19145c578edad8137c62c78c6ba9b390b295239123de49105783993638e8d3fa"
    sha256 cellar: :any, sonoma:        "55da7578c9dab05dbd4df01f6fd972553a9a13ea089f83024955a78bbb868e2a"
    sha256 cellar: :any, arm64_linux:   "e2a89837d7f92ba25cd1c39370b7894356184fb8b738f9823ec0321ea98649a2"
    sha256 cellar: :any, x86_64_linux:  "4f697c79b562f9a91a4912d7859b21b0ef8a12963b32378b331194da016ccc29"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <reliable.h>
      #include <stdio.h>

      int main() {
        if (reliable_init() != RELIABLE_OK) {
          return 1;
        }
        printf("%s", RELIABLE_VERSION_FULL);
        reliable_term();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lreliable", "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end