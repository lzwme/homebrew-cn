class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:ctags.io"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20250511.0.tar.gz"
  version "p6.1.20250511.0"
  sha256 "97573f69636766a3f5a3b485fbd3a79311964fa2e4b92a459051310090c0fbd2"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5d39ede94ca382814fca5ed562ee3539563a122c755853e71e8c547df08c7164"
    sha256 cellar: :any,                 arm64_sonoma:  "ff793daa4f92117c1a174b61507a5a7a16047003477041b6ac71eb82af357ed5"
    sha256 cellar: :any,                 arm64_ventura: "ec76e1a177549c123031fa767e81b8d328001a82922563bb522924c122f48957"
    sha256 cellar: :any,                 sonoma:        "3dd774fd951c7eb62cc4e3cd9c49a39a1703054d113b21a286738be3c4e4a90a"
    sha256 cellar: :any,                 ventura:       "f4f652013de6a5ac5e63e68b9010e53dfdab61e133b9e822aa69bdc52e5b4e81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c106cc7736c45aff08ec2e5e808376d491ce945da7d9966db4a3033662de2e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11bc01139084b84733d37b82010f2387374e332189145a3dac61b6075c731d65"
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