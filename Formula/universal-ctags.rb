class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://ghproxy.com/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230730.0.tar.gz"
  version "p6.0.20230730.0"
  sha256 "85ee103b7204aef0b9d54855204f6ad3257b5cfa4487ed265f1d4a56d1b92237"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6680406827afa8f3cd22c3a1779b3895f0c99afa119844bcd6f357f37659d269"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c4f6a8157e516050f593ceef482372253bed856d3bf1de03b9b123131355ef7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e4334c9c173f849b343a93efb3e95f4c43412dd707ee1d9cd23528bf0c43b53"
    sha256 cellar: :any_skip_relocation, ventura:        "0e6960c958401a02589fe7d9fe3c5034e5e35e405bf726e20407accb2adffc7a"
    sha256 cellar: :any_skip_relocation, monterey:       "1612aa5e158d5355487cbfe2c86e988bbb91933be133a36de428a83aefff4617"
    sha256 cellar: :any_skip_relocation, big_sur:        "596d36ca94e006cbcadd06832226155357217ba7dd44ff752f9965670760dee8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d444aedfe73cfb6e6f3efb022223878764e4b4ad9336b2188b1470a18251f137"
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