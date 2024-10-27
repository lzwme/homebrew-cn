class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20241027.0.tar.gz"
  version "p6.1.20241027.0"
  sha256 "354c6e6cf80ac691c018c0616ab6fad28a33760355728a02c092da6451aef932"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9e944cff4c2d17edfa83e841c25741ccf559184a812a951f2bfe4132ecb0cae6"
    sha256 cellar: :any,                 arm64_sonoma:  "15719a5718a7e909df78a4a1167609e495c912dcad6c89969edfd65b65d6fcb0"
    sha256 cellar: :any,                 arm64_ventura: "7d5661cca9e3e76a4e32077234601216ef7377ee202a632ef8190f3f2be2cca7"
    sha256 cellar: :any,                 sonoma:        "1fe219ce28b30136e1e06b3d220f0828192956460814a2be4b11c4d2d3291cf0"
    sha256 cellar: :any,                 ventura:       "7201d317a8587930a9b8b1cf6f0bf44d573f296eb42ff8f17b5726b3df1b1a8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4856f475a1c33604c2ada6af32590555c6206a760a2d084a83e238821ef73178"
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