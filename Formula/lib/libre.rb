class Libre < Formula
  desc "Toolkit library for asynchronous network IO with protocol stacks"
  homepage "https:github.combaresipre"
  url "https:github.combaresiprearchiverefstagsv3.20.0.tar.gz"
  sha256 "26c946b69d3e4bafff60e5d09c7e01ccb2b097d5b732cbeb4043399a86a4bc0c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fe2e9ccd497efac709ac09b856b7b272d26f45a48b899841295a596e7e1a69bb"
    sha256 cellar: :any,                 arm64_sonoma:  "e646e507a43a3490347910728e8fbf408718c45986931dc21e5c1c5b45d870c6"
    sha256 cellar: :any,                 arm64_ventura: "7a2f0be826886f8cd9f57e813d94c1c7d4aaf9c6828fa50d1c7941e7a26fb70e"
    sha256 cellar: :any,                 sonoma:        "5b94c71ef6706707aac1477f95cb79592e4fb3acc40e768b0c4e3af1c94c39a4"
    sha256 cellar: :any,                 ventura:       "4cccb18c0f61e8899d269081c54e4e450175a2fa107fac58c69ed0933b5e455b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8855ce516e0f8e8e5538d01513659fcfa16cfea88bc4692f4cd8d96e2ac56c80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98cdded0ac11317f97be3703b2e55a67ae9fbf907dcd617db07819cde33c7005"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cmake", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <stdint.h>
      #include <rere.h>
      int main() {
        return libre_init();
      }
    C
    system ENV.cc, "-I#{include}", "-I#{include}re", "test.c", "-L#{lib}", "-lre"
  end
end