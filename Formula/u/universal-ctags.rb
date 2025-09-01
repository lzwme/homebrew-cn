class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://ctags.io/"
  url "https://ghfast.top/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.2.20250831.0.tar.gz"
  version "p6.2.20250831.0"
  sha256 "49c9ec35533145145375833abdd549e136e19f9557182f40d63648bd6861a8cc"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "be8de6d673c7d5f69730ed444a37ac0681efb72e1ee8b42f217dd84ea64ff1bb"
    sha256 cellar: :any,                 arm64_sonoma:  "01d4a90968ba17abec5f333ecde872358605db727d1fa60a78c120fe9d402649"
    sha256 cellar: :any,                 arm64_ventura: "eb6f939323a6bae3a886bfc10e357e31eb3592d9f9968fb5498c5e4e6781ba88"
    sha256 cellar: :any,                 sonoma:        "076d5951a39e65746097a0c84ca333be43b3379e8327b683e99f728755b95794"
    sha256 cellar: :any,                 ventura:       "6e5643d27340817f05de3a33a57b348dc5fbbaf2a87eb56c894ff85106e8f99a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e55d20bf49419c98d8e68a94d9b2a4ad22a7986ac6bb3d48f9b01703d12ad26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30528a78b64b8a2ca5cf1c18404b165c5e777fc8877c8c2093a8f8bd22b3cb93"
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

  conflicts_with "ctags", because: "both install `ctags` binaries"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    system bin/"ctags", "-R", "."
    assert_match(/func.*test\.c/, File.read("tags"))
  end
end