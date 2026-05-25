class Mt32emu < Formula
  desc "Multi-platform software synthesiser"
  homepage "https://github.com/munt/munt"
  url "https://ghfast.top/https://github.com/munt/munt/archive/refs/tags/libmt32emu_2_8_2.tar.gz"
  sha256 "d4778cf89b054ba7ab410ffcb02ecf1629fa32b5b60838addec99eb93804fdcb"
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
    sha256 cellar: :any,                 arm64_tahoe:   "0b798d8a0e855ce0ab76eb0b02d7a2fe16335bcc9185017ce65a95adad49ffa2"
    sha256 cellar: :any,                 arm64_sequoia: "ddc5d6afc7e863326d3aa540f2ecd3b4b1218785259d5beb6706a7ba81589c04"
    sha256 cellar: :any,                 arm64_sonoma:  "2a4fbe85aaa7ca8845d46518780fde3e7caf42b1e984c7115430cf916125b051"
    sha256 cellar: :any,                 sonoma:        "8fa7063046ba4a099dd910436177f32667875e0430480457d15dd0a48624cc57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fb476d5e104930546b6535407353220bd256d2ea01a8c60e4f4719a57155783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55a6a022c263ea3b0c816b80b7e93e19dbbc13c24431ed334f95a51ce67d166d"
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