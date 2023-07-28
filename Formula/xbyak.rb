class Xbyak < Formula
  desc "C++ JIT assembler for x86 (IA32), x64 (AMD64, x86-64)"
  homepage "https://github.com/herumi/xbyak"
  url "https://ghproxy.com/https://github.com/herumi/xbyak/archive/refs/tags/v6.71.tar.gz"
  sha256 "caa98213d7f5c86720d06bae22ddb71a6b8bbeeac3d7dbfacc01136bc2e5a9ec"
  license "BSD-3-Clause"
  head "https://github.com/herumi/xbyak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5cbe69034a31cf3bc78168944d0ffdb34c4b2e829af4e40a473db0c67aebb5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5cbe69034a31cf3bc78168944d0ffdb34c4b2e829af4e40a473db0c67aebb5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5cbe69034a31cf3bc78168944d0ffdb34c4b2e829af4e40a473db0c67aebb5c"
    sha256 cellar: :any_skip_relocation, ventura:        "d5cbe69034a31cf3bc78168944d0ffdb34c4b2e829af4e40a473db0c67aebb5c"
    sha256 cellar: :any_skip_relocation, monterey:       "d5cbe69034a31cf3bc78168944d0ffdb34c4b2e829af4e40a473db0c67aebb5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5cbe69034a31cf3bc78168944d0ffdb34c4b2e829af4e40a473db0c67aebb5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f53e1931b02c083efb09f6edd7f89995d770f43490eff063fb01f534bc61e91"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <xbyak/xbyak_util.h>

      int main() {
        Xbyak::util::Cpu cpu;
        cpu.has(Xbyak::util::Cpu::tSSE42);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-c", "-I#{include}"
  end
end