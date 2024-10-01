class Libpq < Formula
  desc "Postgres C API library"
  homepage "https:www.postgresql.orgdocscurrentlibpq.html"
  url "https:ftp.postgresql.orgpubsourcev17.0postgresql-17.0.tar.bz2"
  sha256 "7e276131c0fdd6b62588dbad9b3bb24b8c3498d5009328dba59af16e819109de"
  license "PostgreSQL"

  livecheck do
    url "https:ftp.postgresql.orgpubsource"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)?["' >]}i)
  end

  bottle do
    sha256 arm64_sequoia: "b0ce742bd7027442b48fd665367048856c44bdc0aad8b8189aa2015456d96e5c"
    sha256 arm64_sonoma:  "85f7d3d183a0959b8fec6f888b5b69f409281da844499e8ac32ba4ec7d6a2ed9"
    sha256 arm64_ventura: "f0b36a3460c0f1fa450aad4b2d686fea44a7eb3e04ee75b3b034fda38f10f9d8"
    sha256 sonoma:        "cb6b96bd419f966dd7865f8fdfd193ebe6fb59d551c9b248473d87e385426b7c"
    sha256 ventura:       "513bc08c47e1638fd77209dfb8cc5f8be2fc48e308687613d924e2ae1fcb6c3e"
    sha256 x86_64_linux:  "2ecaed074cd7bc5ed53aad3d8ee71862192451a946caa3c27d44c75cd02f5bd4"
  end

  keg_only "conflicts with postgres formula"

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
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
    (testpath"libpq.c").write <<~EOS
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
    EOS
    system ENV.cc, "libpq.c", "-L#{lib}", "-I#{include}", "-lpq", "-o", "libpqtest"
    assert_equal "Connection to database attempted and failed", shell_output(".libpqtest")
  end
end