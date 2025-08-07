class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://ghfast.top/https://github.com/baresip/re/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "7cef2b2b3cdbbd857cc12fdf429de1e74cb540e7cf9f1abc2dc5a90acee6b06a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6fa8ec004faf015384b9e1f4cb54e6a7268ed5cb3e159a579c0dd6cfb6a445aa"
    sha256 cellar: :any,                 arm64_sonoma:  "87a22f1377a556a2d45d386606a9293bab63f3752d8d0556efd75be662111f31"
    sha256 cellar: :any,                 arm64_ventura: "ad3a440df07b37e0147e059b82164777b6f6edacbd4622c5a61f275e9dd12e07"
    sha256 cellar: :any,                 sonoma:        "b2cccf673e80e7380d15c50fd0bfc9a04bdb2ed3f9cabd2a00bf529934ad90aa"
    sha256 cellar: :any,                 ventura:       "87713cefae647297973e6e5f811b3258ed68ab5a2e800ee895fdbf7de7fd5997"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d70a88655c5b365480eac3412ab2a0ff996af82104940fd79798e0283d1dae24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adaf223351e235cea532093440ac37ca6d3792938a04cf1f8beedf8d816c35f0"
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
    (testpath/"test.c").write <<~C
      #include <stdint.h>
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    C
    system ENV.cc, "-I#{include}", "-I#{include}/re", "test.c", "-L#{lib}", "-lre"
  end
end