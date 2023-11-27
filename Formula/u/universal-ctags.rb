class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://ghproxy.com/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20231126.0.tar.gz"
  version "p6.0.20231126.0"
  sha256 "bdab92513e64599d51aefd04ab98d14d0bbe3b19529a9ba31208f06e5549baec"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4aa448272e4003cf3beae059c75f5756060d39847aed6e573e939d47106225df"
    sha256 cellar: :any,                 arm64_ventura:  "25a95be1f70bad2c53e75ffadbf2c6466b0fcd5751b14fa216f6e0c0f9bff89d"
    sha256 cellar: :any,                 arm64_monterey: "c44b3afe630106ccae1159ec1dea2257b642df6b9e514796e76c360a5a48738e"
    sha256 cellar: :any,                 sonoma:         "47982394dd884812eb633d7db8ab211fc1fdce30314627f69fc10ffc97bf74bf"
    sha256 cellar: :any,                 ventura:        "c54c6181dc3e3c51740c0052aab0a9e82d7fac4e6bfb414c2f04eb0a543597a8"
    sha256 cellar: :any,                 monterey:       "dd590aa8b863cfc527c1cdcc793a9c0843e00f8bbede2547a97ba1318e01a9cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a73999d59ca45ce197925ee8bb41517bcb013cee1250a57abf7a06b7b03c2c9"
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