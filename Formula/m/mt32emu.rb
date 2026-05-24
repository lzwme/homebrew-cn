class Mt32emu < Formula
  desc "Multi-platform software synthesiser"
  homepage "https://github.com/munt/munt"
  url "https://ghfast.top/https://github.com/munt/munt/archive/refs/tags/libmt32emu_2_8_1.tar.gz"
  sha256 "569c0a0fc106438d6eb612fb022a62c7b5fe7536d2759f5f0eb3a2c9c58f7280"
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
    sha256 cellar: :any,                 arm64_tahoe:   "4038a43e8d23a5bbf07b6e58edb840ae60afbd8f8d30ca39a92ee7091685f464"
    sha256 cellar: :any,                 arm64_sequoia: "d58ceed4c9722e5ce3425106052692c48a50363d67efff4ee2afc7e6c4ca49f3"
    sha256 cellar: :any,                 arm64_sonoma:  "82579909d52e3186a682e86f6ba62c0c9bdaa85c10994d48a68dce9762ce35e7"
    sha256 cellar: :any,                 sonoma:        "ac7910dd3887b839b350b4ba00391365cb572134b27d79f3e3a02a96461d2957"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c6c2fdf8b90cd65bc7b75bde2bd57d6be12298c053d4e4cd398869066bd67fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "924ca99f0011442a48f9bd498486f80643f925c182f2fc659c7ef7ea4e901d16"
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