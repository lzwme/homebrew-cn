class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://ghproxy.com/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230806.0.tar.gz"
  version "p6.0.20230806.0"
  sha256 "77f13bbc0443556caf871a38e066f1b62415a80bceca6d0ac41fcecd4f78460c"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8296e453d8ffe8c4070a13b37937609dc6bc79e0ed062e12e3b8fe9d512f308"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9db62b4252226b437865ecf688cb92c175190f1d08029927fa9a104d2ac20e57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b67bdc7812e8a0b33c4346266ad440a1385956752639a3ad4bde277a2a9dc51f"
    sha256 cellar: :any_skip_relocation, ventura:        "4420aefc49fe23c874ecd66c96dc991a8e37c557d0c26ce2f4cccc563a01c025"
    sha256 cellar: :any_skip_relocation, monterey:       "01babb98d0857602467c3052aa49f9aa648909c5743ce7ebc980a58c413709ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "083fe56e75910de003c064f85736bb6924123a1dbdb846b0ce9e941ba0bd4088"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7990c57c59899cfda92dd36153fe22cd30fd11deeb31ab18097cd94f9c2f481"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libyaml"
  depends_on "pcre2"

  uses_from_macos "libxml2"

  conflicts_with "ctags", because: "this formula installs the same executable as the ctags formula"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>

      void func()
      {
        printf("Hello World!");
      }

      int main()
      {
        func();
        return 0;
      }
    EOS
    system bin/"ctags", "-R", "."
    assert_match(/func.*test\.c/, File.read("tags"))
  end
end