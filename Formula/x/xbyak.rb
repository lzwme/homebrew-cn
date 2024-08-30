class Xbyak < Formula
  desc "C++ JIT assembler for x86 (IA32), x64 (AMD64, x86-64)"
  homepage "https:github.comherumixbyak"
  url "https:github.comherumixbyakarchiverefstagsv7.07.1.tar.gz"
  sha256 "9f2a1215ed0511e421895d57e2681981f9f9f8fb952655919a9cf859cfe474ae"
  license "BSD-3-Clause"
  head "https:github.comherumixbyak.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "52308a8e4792ef90f06c6c6952582c348da6d12113d6b2aeeb494ec3ceb11743"
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