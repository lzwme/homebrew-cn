class Xbyak < Formula
  desc "C++ JIT assembler for x86 (IA32), x64 (AMD64, x86-64)"
  homepage "https://github.com/herumi/xbyak"
  url "https://ghfast.top/https://github.com/herumi/xbyak/archive/refs/tags/v7.29.1.tar.gz"
  sha256 "84ad91e1a47b45bd65e1e737aa5edf3d1644843e5df9746c2ecada406f676504"
  license "BSD-3-Clause"
  head "https://github.com/herumi/xbyak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b37107a2e0c27fd8e58f18a576f01585fb06f683abaa027b549766729f7a4cac"
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