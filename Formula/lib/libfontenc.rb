class Libfontenc < Formula
  desc "X.Org: Font encoding library"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libfontenc-1.1.8.tar.xz"
  sha256 "7b02c3d405236e0d86806b1de9d6868fe60c313628b38350b032914aa4fd14c6"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "42a65ad7c8f1cad68b3b2e9c7df796285467748b0b4712f8223c6be3d3eb8444"
    sha256 cellar: :any,                 arm64_sequoia: "8626ef261fd6d6a5e46bfdefd7f2ed5f364b1a7972c9b5cbc7de038cb5479474"
    sha256 cellar: :any,                 arm64_sonoma:  "70449e55e974c4291601719fb9536020039bb3a2834bc8b46ea578d4eb71009a"
    sha256 cellar: :any,                 sonoma:        "63349d6fc6d5e17a036fd1fa20b0e10170fe3c81bdf41bbcf1668a602fb75dfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ac0af70244ad21efebbf51b5dc0c9fe0a7f908fd0e733c48185fa316458b7e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "217c0bb17252ce2fbeaf0ca0958bf10fff8a50a7d93fd75e463f5aecbbfba11e"
  end

  depends_on "font-util" => :build
  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/fonts/fontenc.h"

      int main(int argc, char* argv[]) {
        FontMapRec rec;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end