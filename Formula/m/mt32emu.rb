class Mt32emu < Formula
  desc "Multi-platform software synthesiser"
  homepage "https://github.com/munt/munt"
  url "https://ghfast.top/https://github.com/munt/munt/archive/refs/tags/libmt32emu_2_8_0.tar.gz"
  sha256 "56f9dfde9fcea9c729848d028dfca05e916ba89867c9afe8eacc8325c5aac336"
  license "LGPL-2.1-or-later"
  head "https://github.com/munt/munt.git", branch: "master"

  livecheck do
    url :stable
    regex(/^libmt32emu[._-]v?(\d+(?:[._-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2398a4140fda3581e51b1e5edb544a532c1798fb92bca33c1aa91e6bdc46df57"
    sha256 cellar: :any,                 arm64_sequoia: "ef4c883664605b5495db6af883b4868a654690b494d5e9d76c2e5e72176f5781"
    sha256 cellar: :any,                 arm64_sonoma:  "08ce61e6463d88500c081a63c39e9f1a2cbc25ac29f59d084a9f2d30e33dded8"
    sha256 cellar: :any,                 sonoma:        "0e196de4399378156c9e80b5830e21190406c2a5fb01ec11e1051c9b6718607b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64c1d227971591ebaaa37c79f389c3a108469626b7b82e17c83213fae6213cf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2729ad81889281fb75327ee8351606392dfa93909b9536dfd512ffab85750a9"
  end

  depends_on "cmake" => :build
  depends_on "libsamplerate"
  depends_on "libsoxr"

  def install
    system "cmake", "-S", "mt32emu", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"mt32emu-test.c").write <<~C
      #include "mt32emu.h"
      #include <stdio.h>
      int main() {
        printf("%s", mt32emu_get_library_version_string());
      }
    C

    system ENV.cc, "mt32emu-test.c", "-I#{include}", "-L#{lib}", "-lmt32emu", "-o", "mt32emu-test"
    assert_match version.to_s, shell_output("./mt32emu-test")
  end
end