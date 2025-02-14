class Libpq < Formula
  desc "Postgres C API library"
  homepage "https:www.postgresql.orgdocscurrentlibpq.html"
  url "https:ftp.postgresql.orgpubsourcev17.3postgresql-17.3.tar.bz2"
  sha256 "13c18b35bf67a97bd639925fc581db7fd2aae4d3548eac39fcdb8da74ace2bea"
  license "PostgreSQL"

  livecheck do
    url "https:ftp.postgresql.orgpubsource"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)?["' >]}i)
  end

  bottle do
    sha256 arm64_sequoia: "a7b0daa94e55cc029a4f8a004370bab0e8342bcd977c758008faabe4b0c4e90c"
    sha256 arm64_sonoma:  "c052a28f0b6bfe5a643e980a05dd9b7a7dd3681c04c61eeb2bffcdb9cc9a769c"
    sha256 arm64_ventura: "59b0561eaaf7bc7ba59c5a2b05e14fa155ebecba273c92ffb195dd118be0d823"
    sha256 sonoma:        "d3be8a2df3ded18c000603e4017a1b5f82eee69176bf44bec6cec7100043cb72"
    sha256 ventura:       "e77ca5cfeeb10fdbb2804f60ccda8ca3bd4a4959480904af41202f935892c5ca"
    sha256 x86_64_linux:  "cb6cb466058f4f1db16ac9f739ffad4d38ce87e12b0297753f2857fb5d52a0b9"
  end

  keg_only "conflicts with postgres formula"

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkgconf" => :build
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