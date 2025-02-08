class Xbyak < Formula
  desc "C++ JIT assembler for x86 (IA32), x64 (AMD64, x86-64)"
  homepage "https:github.comherumixbyak"
  url "https:github.comherumixbyakarchiverefstagsv7.23.1.tar.gz"
  sha256 "17678579963314463cf51bd0f9070f33dfe47667754d9b6239de1000e67fe259"
  license "BSD-3-Clause"
  head "https:github.comherumixbyak.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3e4bfa6b03a25342e767d227ba39060e86d9cea88badb5875580c80c9b3de92f"
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