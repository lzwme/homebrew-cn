class Reliable < Formula
  desc "Simple packet acknowledgement system for UDP-based protocols"
  homepage "https://github.com/mas-bandwidth/reliable"
  url "https://ghfast.top/https://github.com/mas-bandwidth/reliable/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "1f3e8cda9780aad3582f267b4728690d1b570d205e620f0596006df9d27d92cb"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7e862dc1cf9bc582bac4f0526a00f7ef7062ffb6b40a87b403b2e394b17579ac"
    sha256 cellar: :any, arm64_sequoia: "3a8a5512b55acb19d3d19e3feb13ab9ae7561eef73d58f2777de6d31d381d325"
    sha256 cellar: :any, arm64_sonoma:  "45bb7cf51ad2203b3ad1aeffa9a2e3e2e949bf2232c570d6753895ff7f691c52"
    sha256 cellar: :any, sonoma:        "fc9960381dcdef571dd445a6fbab8a23cb6d1dbbbc6ef57c2a973d55b8d9bee7"
    sha256 cellar: :any, arm64_linux:   "4b066b538e15fdf3dfed836965cbfe121df46223d9c0c14383b1dfd8f705db48"
    sha256 cellar: :any, x86_64_linux:  "009d3736ba65538703b1983735ac5ab42e03458eb58828d8aec57b14300c57c6"
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