class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:ctags.io"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20250427.0.tar.gz"
  version "p6.1.20250427.0"
  sha256 "d95556c9a59679e1d6be079806af06b15ae6f98c8ae54ed4c3fb883d4e1a0342"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "136e5c1536ea231afda74cb42ffba3b6fbf7db178141d07d91350f85fbcdf4bf"
    sha256 cellar: :any,                 arm64_sonoma:  "6baf93ef5ac7347f3880eb9cffb7f45da91f6fc40d4707cb911079f3c7851c4c"
    sha256 cellar: :any,                 arm64_ventura: "3ef1142b0180cb16689823ccc671c43655a233f5e5b8665724959282de0aa3fb"
    sha256 cellar: :any,                 sonoma:        "6fd4a1be160fdd07a460747184ad4c99964675e642510102cc7f5522e6068f0b"
    sha256 cellar: :any,                 ventura:       "411710154b42e3b086a51d60d303d5162f84f15dc4ec2d9e9dc23460906c1a64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb3f02bb3dd9eac197b11395ef3378d9982789cc8e5e6d7ded712d633eebc6d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7affc980be79c0a7a4f12655104f15c1d9d4f9527e8f366472f903b67f2325d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "jansson"
  depends_on "libyaml"
  depends_on "pcre2"

  uses_from_macos "libxml2"

  conflicts_with "ctags", because: "this formula installs the same executable as the ctags formula"

  def install
    system ".autogen.sh"
    system ".configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath"test.c").write <<~C
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
    C
    system bin"ctags", "-R", "."
    assert_match(func.*test\.c, File.read("tags"))
  end
end