class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20240908.0.tar.gz"
  version "p6.1.20240908.0"
  sha256 "385bb988c9e44ffccf5cdb5ee6d4abecd386da0489845cf55f02d775f6ec358b"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "584a3d998430bc33ec061269b938c4dd2e1add6b395485c2caf2f5ab869bfdc4"
    sha256 cellar: :any,                 arm64_sonoma:   "5648875f28259a06539189a3513c83355a4cab287331e0136a846b61a3dded7f"
    sha256 cellar: :any,                 arm64_ventura:  "e51a9752f4e5339ffad8eb44e4b02c047d2becd4dba98297a18e73e1027f1af5"
    sha256 cellar: :any,                 arm64_monterey: "6acbf8dad559bff18757efb227122bac5ed2670e4fcf31d8943e89664c8eeaab"
    sha256 cellar: :any,                 sonoma:         "ae7bd763ad4e091ee1efe98dc64381268637ce44a5367cae196805e60f1f374c"
    sha256 cellar: :any,                 ventura:        "6e2c450e2bee32a7637e3360ac6647513d6a9cda91c164df9c950d2e65734ce7"
    sha256 cellar: :any,                 monterey:       "f66214079466c1a823d21e635fabc6aeacc6cb160a083b5b5aa86e732a12d41c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0674c6593cd032b4d6d3f74ab25f354e7fca356d7ea3b7a7397b36f195bcb7a4"
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