class Xbyak < Formula
  desc "C++ JIT assembler for x86 (IA32), x64 (AMD64, x86-64)"
  homepage "https:github.comherumixbyak"
  url "https:github.comherumixbyakarchiverefstagsv7.02.tar.gz"
  sha256 "80951838ec1c3cba62f715c97d44dd041fab4f146c73bf4afae86b293b28f9ae"
  license "BSD-3-Clause"
  head "https:github.comherumixbyak.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "600d67b9fce1771bc80833e746806fa1b8b1bd2fe83730529f87c51428f6527a"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <xbyakxbyak_util.h>

      int main() {
        Xbyak::util::Cpu cpu;
        cpu.has(Xbyak::util::Cpu::tSSE42);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-c", "-I#{include}"
  end
end