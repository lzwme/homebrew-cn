class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20240519.0.tar.gz"
  version "p6.1.20240519.0"
  sha256 "bc74d678c1e8ae94b3e4a00591412dbb24c482558bff0d51fcc71509997ad0bc"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7dd65afbae24cb53f522e80de78933d595de2aec082c867de1857665c879de5b"
    sha256 cellar: :any,                 arm64_ventura:  "64b4bd4ec41b1a046a2b1192b7ef5372603f4b9fbd13ac3103084e824fbfad83"
    sha256 cellar: :any,                 arm64_monterey: "c60b27e96940cb2e409dbce5edef6d57eb3caf11ddb2ea714dd09796b9f0847f"
    sha256 cellar: :any,                 sonoma:         "0c21e94ab9434c23825b049f8cb2a59923ff77bc934cba43906fe99f4870cf8a"
    sha256 cellar: :any,                 ventura:        "541fbe3a2a955a1332392dfe75907ed8609838698beace3a783d4753c13ee106"
    sha256 cellar: :any,                 monterey:       "a47a9fc0ffca3a05f6c15aaf7eb398cc6da5d260bc31aa1d269b160c9d484d16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d3f65b14ae839cc187d99d4fe8048f7c5dbe53825871dfa7615d986801275e8"
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