class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://ghproxy.com/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230709.0.tar.gz"
  version "p6.0.20230709.0"
  sha256 "83dfebc0c10ba58372b0cebdaaeaf0650f97b8b1aa67451982d4966e2f21a1f6"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "017014f67a3dc25f815ef320908dcfec91edea03ebb6851672247bd443cd5e54"
    sha256 cellar: :any,                 arm64_monterey: "eb444e40fa526b58d89fb550b1e2d9c829b0772c76fee1d932385f1e353f75d6"
    sha256 cellar: :any,                 arm64_big_sur:  "9ebc5cea2db15e34e5a9256776e65746aabcbbc5d60407f829885aa3b25132c6"
    sha256 cellar: :any,                 ventura:        "4a082f92d92e06c4d777f4cc21a2db4271b09a0dbd0c98e7cf5401bf45e68c06"
    sha256 cellar: :any,                 monterey:       "09bd862c02619f864819ffb340f836f782aef96546000269d4b46c267cf10535"
    sha256 cellar: :any,                 big_sur:        "32f6c50a78cc73294f0fb63fabec164a257e32ba15aa7cb13c2eb14b14cd829a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c5c4d7286f45ff7db9027271e2fbc1be5e173ed7bd66f3ab38eb66b4c8b8b5a"
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