class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20240630.0.tar.gz"
  version "p6.1.20240630.0"
  sha256 "32d9a271181e735d148849a20b5db3e4d3acf062c4448edccc43cb791cd14750"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8f03544620a20aa29d4733deae34359e3326e20e9b13fb8f32434a6b390f2be3"
    sha256 cellar: :any,                 arm64_ventura:  "f2fdd4c50ebc17b69a50fd4cbfe2c8c04676f9a47f0a800267c38f201e3790e2"
    sha256 cellar: :any,                 arm64_monterey: "17ff5fc9dc62991bb5ebdfc844faed4805b4c79aeb55e42752a8754f0eeb8cf9"
    sha256 cellar: :any,                 sonoma:         "7d0ff3273d4fa60e9e280e9cc86730132fa6a13cd06685dea6dc297a68dd5de2"
    sha256 cellar: :any,                 ventura:        "46d81664fe1943e91aa01b6d168756b2060d38c9de952f88755ec29f465dfea8"
    sha256 cellar: :any,                 monterey:       "08e0c021f7d1a14a833224269d4722c4264f49ebc3eae329bb40034f572446ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a23d0d7619145862dedc16d44ac1fa4d347a900f5f68846c1560288ee0eb9f75"
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