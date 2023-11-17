class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "https://uncrustify.sourceforge.net/"
  url "https://ghproxy.com/https://github.com/uncrustify/uncrustify/archive/refs/tags/uncrustify-0.78.0.tar.gz"
  sha256 "377efec187c26c7ad77900d94032fa51b029831c69442d607a6e53ef2115928f"
  license "GPL-2.0-or-later"
  head "https://github.com/uncrustify/uncrustify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a8ed5c9fcb5e0c53dc49a240a91a8a0257d58d5c2074aa912b29b3e23fdd7c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6129c84606d7e5f79535f2cc94f59a8a0ca4c69ed5ef972c25786e673e66fe4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "700691aa2dc80d3cf3ee6316cb1b306ded83c6c6cb6c88a7be4b39e591ff0c1b"
    sha256 cellar: :any_skip_relocation, sonoma:         "f817a117984a21b743d6f0887fd8fb414809217be4690970d4f463616d2a7ab7"
    sha256 cellar: :any_skip_relocation, ventura:        "31d8e207d06d5428ad8bc6f142384b3e74c6a50cf2950a39072b1dd6dd045ae7"
    sha256 cellar: :any_skip_relocation, monterey:       "d0b2d2a35db8f44ec5f9df0fe2859ee3f6f8ff2160abbb5ea4d2aa86c8957fa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9678ab4b9773dc094a8b7f032c4f75071f8c68a41b5d7d3ee971fc8fe8bd875a"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  fails_with gcc: "5"

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    doc.install (buildpath/"documentation").children
  end

  test do
    (testpath/"t.c").write <<~EOS
      #include <stdio.h>
      int main(void) {return 0;}
    EOS
    expected = <<~EOS
      #include <stdio.h>
      int main(void) {
      \treturn 0;
      }
    EOS

    system "#{bin}/uncrustify", "-c", "#{doc}/htdocs/default.cfg", "t.c"
    assert_equal expected, File.read("#{testpath}/t.c.uncrustify")
  end
end