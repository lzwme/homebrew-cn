class Libgsf < Formula
  desc "IO abstraction library for dealing with structured file formats"
  homepage "https:gitlab.gnome.orgGNOMElibgsf"
  url "https:download.gnome.orgsourceslibgsf1.14libgsf-1.14.53.tar.xz"
  sha256 "0eb59a86e0c50f97ac9cfe4d8cc1969f623f2ae8c5296f2414571ff0a9e8bcba"
  license "LGPL-2.1-only"

  bottle do
    sha256 arm64_sequoia: "186311b43c3be3ef3cd8d29c257b1c1f5449022658c3523bc0897f75d2967765"
    sha256 arm64_sonoma:  "ff6100584fe708188b457967ee517b9cd48337f45d4cb91906b5a6a91e92515c"
    sha256 arm64_ventura: "cbb7b8877bf62f1721c27235d5a76ce890341063e428bf17bc8b03e91512f6eb"
    sha256 sonoma:        "07cc0b89f9b8cf89e170f72122e452446b292bcc882aab9a8d18504083fc4c17"
    sha256 ventura:       "502444a3812646ac8a35a9beb5f06346ca33ad5b968f904f0fba056d63ffa315"
    sha256 x86_64_linux:  "fa65b00122a957bacfebe171cc2ee998d059cd2e43c88784cbb1e7da47ba1934"
  end

  head do
    url "https:github.comGNOMElibgsf.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    configure = build.head? ? ".autogen.sh" : ".configure"
    system configure, *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin"gsf", "--help"
    (testpath"test.c").write <<~EOS
      #include <gsfgsf-utils.h>
      int main()
      {
          void
          gsf_init (void);
          return 0;
      }
    EOS
    system ENV.cc, "-I#{include}libgsf-1",
           "-I#{Formula["glib"].opt_include}glib-2.0",
           "-I#{Formula["glib"].opt_lib}glib-2.0include",
           testpath"test.c", "-o", testpath"test"
    system ".test"
  end
end