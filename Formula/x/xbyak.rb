class Xbyak < Formula
  desc "C++ JIT assembler for x86 (IA32), x64 (AMD64, x86-64)"
  homepage "https:github.comherumixbyak"
  url "https:github.comherumixbyakarchiverefstagsv7.24.1.tar.gz"
  sha256 "bf1442972058381b6ed43a3a9df5a93b854dd81b7c30a6d73ab6acbc061b7a18"
  license "BSD-3-Clause"
  head "https:github.comherumixbyak.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "884c9ea85b697c35020b2d6c3aa2b6ebc7b92248dca45a653cb12d744dcbc9cc"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <xbyakxbyak_util.h>

      int main() {
        Xbyak::util::Cpu cpu;
        cpu.has(Xbyak::util::Cpu::tSSE42);
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-c", "-I#{include}"
  end
end