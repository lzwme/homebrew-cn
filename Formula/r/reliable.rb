class Reliable < Formula
  desc "Simple packet acknowledgement system for UDP-based protocols"
  homepage "https://github.com/mas-bandwidth/reliable"
  url "https://ghfast.top/https://github.com/mas-bandwidth/reliable/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "a1dee46b5c2464711755648873e8aea453a4221af5a87f87ff003e1586af977a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2efdd0690171c2d319456a25d7b22dbb8db45fafc2c2de97bb3a307d4e4433d9"
    sha256 cellar: :any, arm64_sequoia: "6b5590115d242ad331ac762c0f99c60c9920267993a6fd287df8bd9c1c36da94"
    sha256 cellar: :any, arm64_sonoma:  "5ba66090183552aa3b8313f9390fccdf1692978945410ab9cc3706f5e041c3fa"
    sha256 cellar: :any, sonoma:        "66735ace6599454e8b892b261b2a008f6d1e9d211c50451ef13130503cb4daf4"
    sha256 cellar: :any, arm64_linux:   "27180d891dea49cb75f42a68788f45116080568c8a425447a73c0e22a111bfa0"
    sha256 cellar: :any, x86_64_linux:  "76fa42b2f5fe127dc1a3c857a43b2ac5ad61f79d360f68fed955083755d4f1a0"
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