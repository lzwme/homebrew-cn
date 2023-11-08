class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://ghproxy.com/https://github.com/baresip/re/archive/refs/tags/v3.6.2.tar.gz"
  sha256 "8f77a51b0fecc9d903b1151607e214ad7380756dae5efa5e860b2953513bb260"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cbcbf377856b5c5456e7fb41d52b2546a8d7b3ebe1f65ee7c8cc188436e59b23"
    sha256 cellar: :any,                 arm64_ventura:  "87368ada1f4544c4da3d12d25bfc970b8be56f504817dc476b3117c49ad5e68d"
    sha256 cellar: :any,                 arm64_monterey: "5e37eef699bfa39002674a76c711a2fa429eef849251e1893db834e0706c83dc"
    sha256 cellar: :any,                 sonoma:         "a41de567eba2892036fd9a5aca303e2ad030f11c0a66602b92d9cdee7d01903f"
    sha256 cellar: :any,                 ventura:        "52c4031a7d3209a0e682a719dc332894bfb61b0053690bca6490801a7ab1b994"
    sha256 cellar: :any,                 monterey:       "fe7579d07dec872ac0be1f8be6c717e8e6f908634d04a25ba1c29482376faf22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba4bd43e31b87cdf857a5f84b7ef48194580d6b200dd16f260a8a6cbc415f4b7"
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
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    EOS
    system ENV.cc, "-I#{include}", "-I#{include}/re", "test.c", "-L#{lib}", "-lre"
  end
end