class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https:github.comso-fancydiff-so-fancy"
  url "https:github.comso-fancydiff-so-fancyarchiverefstagsv1.4.4.tar.gz"
  sha256 "3eac2cfb3b1de9d14b6a712941985d6b240b7f3726c94a5e337317c7161e869d"
  license "MIT"
  head "https:github.comso-fancydiff-so-fancy.git", branch: "next"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0a4e3b0b333e0fb2f2ea0f6b3ddaa2d2f024583541238975c39f0008ea7044eb"
  end

  def install
    libexec.install "diff-so-fancy", "lib"
    bin.install_symlink libexec"diff-so-fancy"
  end

  test do
    diff = <<~EOS
      diff --git ahello.c bhello.c
      index 8c15c31..0a9c78f 100644
      --- ahello.c
      +++ bhello.c
      @@ -1,5 +1,5 @@
       #include <stdio.h>

       int main(int argc, char **argv) {
      -    printf("Hello, world!\n");
      +    printf("Hello, Homebrew!\n");
       }
    EOS
    assert_match "modified: hello.c", pipe_output(bin"diff-so-fancy", diff, 0)
  end
end