class Libpq < Formula
  desc "Postgres C API library"
  homepage "https:www.postgresql.orgdocscurrentlibpq.html"
  url "https:ftp.postgresql.orgpubsourcev17.0postgresql-17.0.tar.bz2"
  sha256 "7e276131c0fdd6b62588dbad9b3bb24b8c3498d5009328dba59af16e819109de"
  license "PostgreSQL"
  revision 2

  livecheck do
    url "https:ftp.postgresql.orgpubsource"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)?["' >]}i)
  end

  bottle do
    sha256 arm64_sequoia: "a7d324023a64b4c30827a296e90b013c6568985e0a2a0ca07267ddbb57ed6b64"
    sha256 arm64_sonoma:  "2bd5ab7f788d564457ca517c3301444b0f000c326cb4e44a253077b2c5d0f8cb"
    sha256 arm64_ventura: "2ddaa7ed1c71d98592877c034df221bd3d9fdfcb4b4fe1aee1f36a751693891a"
    sha256 sonoma:        "6df62d3e1f4ed6e379acf636a7e2516fb06af0c07da39daa1cb669b125f56794"
    sha256 ventura:       "da2f9440626b64ff20efa7844b0941b661b4cd15a8e9ce0be8e5fc14ae44a544"
    sha256 x86_64_linux:  "8f8e4ead281acc6b88d933d2ed995211c016cf9050dba494e1103f0eb57d5afa"
  end

  keg_only "conflicts with postgres formula"

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c@76"
  # GSSAPI provided by Kerberos.framework crashes when forked.
  # See https:github.comHomebrewhomebrew-coreissues47494.
  depends_on "krb5"
  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libxml2" => :build
  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "zlib"

  on_linux do
    depends_on "readline"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}xmlcatalog"

    system ".configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-gssapi",
                          "--with-openssl",
                          "--libdir=#{opt_lib}",
                          "--includedir=#{opt_include}"
    dirs = %W[
      libdir=#{lib}
      includedir=#{include}
      pkgincludedir=#{include}postgresql
      includedir_server=#{include}postgresqlserver
      includedir_internal=#{include}postgresqlinternal
    ]
    system "make"
    system "make", "-C", "srcbin", "install", *dirs
    system "make", "-C", "srcinclude", "install", *dirs
    system "make", "-C", "srcinterfaces", "install", *dirs
    system "make", "-C", "srccommon", "install", *dirs
    system "make", "-C", "srcport", "install", *dirs
    system "make", "-C", "doc", "install", *dirs
  end

  test do
    (testpath"libpq.c").write <<~C
      #include <stdlib.h>
      #include <stdio.h>
      #include <libpq-fe.h>

      int main()
      {
          const char *conninfo;
          PGconn     *conn;

          conninfo = "dbname = postgres";

          conn = PQconnectdb(conninfo);

          if (PQstatus(conn) != CONNECTION_OK)  This should always fail
          {
              printf("Connection to database attempted and failed");
              PQfinish(conn);
              exit(0);
          }

          return 0;
        }
    C
    system ENV.cc, "libpq.c", "-L#{lib}", "-I#{include}", "-lpq", "-o", "libpqtest"
    assert_equal "Connection to database attempted and failed", shell_output(".libpqtest")
  end
end