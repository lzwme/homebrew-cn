class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://ghproxy.com/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230917.0.tar.gz"
  version "p6.0.20230917.0"
  sha256 "8852451784ace0be9dca0b9b50269ff90cb8e744bad08148a175dc0904eb2d7f"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6323ab9922dca4d04edba613b59713cd4f0cf83c5ecd606265a0bd23bc6500fc"
    sha256 cellar: :any,                 arm64_ventura:  "ad96506d8af4537dd8e07dbb921c7f5da6a579d28f4e557f615cc4c7768f7fc4"
    sha256 cellar: :any,                 arm64_monterey: "7fc151b2f150178d0c4af93ba0f068d4de6d3be4fa2709c40a6f7d72712d2cea"
    sha256 cellar: :any,                 arm64_big_sur:  "c1f9b8ef9e3424fca59ddb85385a51600de19c8a49c55886b3621fe229754156"
    sha256 cellar: :any,                 sonoma:         "df4694056cd0c1743c4d4aee994deecd1f86bcea835c51ee1a1d6270ca572d93"
    sha256 cellar: :any,                 ventura:        "5e36b27aa85d2df7115a6729cf2943ddba27b6e02bf4f6da4a8be5b2cb9391ca"
    sha256 cellar: :any,                 monterey:       "4d24957320888c9152706c64b15edcb8e42f15b6645394399b25209ec5d02495"
    sha256 cellar: :any,                 big_sur:        "d05eb06100420a62e8cd6b4649fe14c4672659d13bc0e6d6233c37e3f9e71dfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2868758ecc3a61e92ddf849602934931af8d79a7ee0cefda3c07c31ebf3b07a3"
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