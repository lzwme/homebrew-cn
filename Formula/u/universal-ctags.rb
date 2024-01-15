class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20240114.0.tar.gz"
  version "p6.1.20240114.0"
  sha256 "ad50367d7d3c19f44c4db6d3c99c1e3d511f9d0014d9efbd5c82896eef44e4f2"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7d906b4150206dd363c8a968af4ef6f8eb48ca1ebde98e81c7976b6fbd12a865"
    sha256 cellar: :any,                 arm64_ventura:  "d8b412a1f853c166153ece72f905c1d3bad239b3ccbc144516fe5be2c45ad8ca"
    sha256 cellar: :any,                 arm64_monterey: "d9dce4017aa7e8bbbbba8cf5dd265b5f87e321c02ba27b9471367279003838ba"
    sha256 cellar: :any,                 sonoma:         "d946f90a12627d4a9ce8d5f3f6b7fa749a4f20d2cfae734a6f290b2954eed303"
    sha256 cellar: :any,                 ventura:        "9552e43e5de5e298af85df382fa414edeba1272d15a3efd530996157e594233b"
    sha256 cellar: :any,                 monterey:       "9aa0ee96abd6b54f8ef2c1fa53ad63062b80db84ed4ef5b7ebd66786ddce5e3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90f7d8377ce3c04a50ede842963ddc6e316caf8a1a59372142c935d1c0f3879e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
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
    (testpath"test.c").write <<~EOS
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
    system bin"ctags", "-R", "."
    assert_match(func.*test\.c, File.read("tags"))
  end
end