class Xbyak < Formula
  desc "C++ JIT assembler for x86 (IA32), x64 (AMD64, x86-64)"
  homepage "https://github.com/herumi/xbyak"
  url "https://ghfast.top/https://github.com/herumi/xbyak/archive/refs/tags/v7.32.1.tar.gz"
  sha256 "47e2b0c2247cca8751ba63a61b65cb607781c8eeec1acf20aa84bd35c2cf31b6"
  license "BSD-3-Clause"
  head "https://github.com/herumi/xbyak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ceb883e7713be5888f1503fc9138fec566016c223c953a5b80f4efcdf95765b5"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <xbyak/xbyak_util.h>

      int main() {
        Xbyak::util::Cpu cpu;
        cpu.has(Xbyak::util::Cpu::tSSE42);
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-c", "-I#{include}"
  end
end