class Libgsf < Formula
  desc "I/O abstraction library for dealing with structured file formats"
  homepage "https://gitlab.gnome.org/GNOME/libgsf"
  url "https://download.gnome.org/sources/libgsf/1.14/libgsf-1.14.54.tar.xz"
  sha256 "d18869264a2513cfb071712486d115dada064ff8a040265b49936bca06f17623"
  license "LGPL-2.1-only"

  bottle do
    sha256 arm64_tahoe:   "9111d73113ddc144436785dff7104d4b04058e8ef05e044a8455ab2b2ec7fc48"
    sha256 arm64_sequoia: "835cf0c7e64062e8aab5e7cbdfe0d574628bfb0af4a8e0aad1401d84b3049af0"
    sha256 arm64_sonoma:  "c822f4fe6c09e5edfd97ad4eb868e77133af4b38c559e13c6435f1d96687f9f2"
    sha256 sonoma:        "8d01ec5f3edd2f6ea65ab3cd124c355001735919ee83d72a258f6cf3251f0e1f"
    sha256 arm64_linux:   "299f0f726fde02e762cad49687d38c3e8345b1bd5298231eb77bb141554ff2c5"
    sha256 x86_64_linux:  "3129eaa007d87b4c609d4eac08a138c160399b5251062b6ecf555abf0a087e4b"
  end

  head do
    url "https://github.com/GNOME/libgsf.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "glib"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"gsf", "--help"
    (testpath/"test.c").write <<~C
      #include <gsf/gsf-utils.h>
      int main()
      {
          void
          gsf_init (void);
          return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test",
           "-I#{include}/libgsf-1",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include"
    system "./test"
  end
end