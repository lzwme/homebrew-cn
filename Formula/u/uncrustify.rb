class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "https:uncrustify.sourceforge.net"
  url "https:github.comuncrustifyuncrustifyarchiverefstagsuncrustify-0.80.0.tar.gz"
  sha256 "8df1a4fb9aeb6c59d21fd328bb8fd34be7a11aef24310636df5cadca0900c729"
  license "GPL-2.0-or-later"
  head "https:github.comuncrustifyuncrustify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f0a849b0298e6e686a8977a3435af8f7364fa5b5a8e46cdd5919682935f1eab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8c5c7b53f48d9ee3fe209d091c176820d206101e466daab49d1720722bbbd2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26f5ad867e2ec12ba0afe4f08ccd17aec03e027a14bdcb417148cf6a26ee84e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e32b638090c9faebaee42b300032d46fef42f2914fba7b31c4aede3711d73f2e"
    sha256 cellar: :any_skip_relocation, ventura:       "c6153d632bb84b834863b881f9025a18c420dcf644badd34428333fe3602689c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a59613a7c4325389e8d369099c5d908fd5cb3716fd51dbc160ec91f6eae666e9"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    doc.install (buildpath"documentation").children
  end

  test do
    (testpath"t.c").write <<~C
      #include <stdio.h>
      int main(void) {return 0;}
    C

    expected = <<~C
      #include <stdio.h>
      int main(void) {
      \treturn 0;}
    C

    system bin"uncrustify", "-c", doc"htdocsdefault.cfg", "t.c"
    assert_equal expected, (testpath"t.c.uncrustify").read
  end
end