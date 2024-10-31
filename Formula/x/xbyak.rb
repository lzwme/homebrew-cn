class Xbyak < Formula
  desc "C++ JIT assembler for x86 (IA32), x64 (AMD64, x86-64)"
  homepage "https:github.comherumixbyak"
  url "https:github.comherumixbyakarchiverefstagsv7.21.tar.gz"
  sha256 "23aad8abc682205ad718d77d51e8e66a569c66de1722b8772d1afb6cbb8d300b"
  license "BSD-3-Clause"
  head "https:github.comherumixbyak.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9c55c1a54f1c3f4a5f14924c97d6c98ea9345e049b61f531430af68efd9b41b0"
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