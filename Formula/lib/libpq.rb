class Libpq < Formula
  desc "Postgres C API library"
  homepage "https:www.postgresql.orgdocscurrentlibpq.html"
  url "https:ftp.postgresql.orgpubsourcev17.1postgresql-17.1.tar.bz2"
  sha256 "7849db74ef6a8555d0723f87e81539301422fa9c8e9f21cce61fdc14e9199dcd"
  license "PostgreSQL"

  livecheck do
    url "https:ftp.postgresql.orgpubsource"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)?["' >]}i)
  end

  bottle do
    sha256 arm64_sequoia: "f84f58fc190da211ee98be839163b0bfa421f8f15f7de9dddce9ee1512b5b119"
    sha256 arm64_sonoma:  "0bd9a799f2557db380ff2f1fbccee604661f2374e9bbdac7d6585a1cb4047d80"
    sha256 arm64_ventura: "906725a4779aa7eae9f5e491eeaa76fb95ebdd46a59faceaa59c2e7030ee6f32"
    sha256 sonoma:        "41cee67436f5e5098f492f427d0c9edb7ae64d5bfdda8b0170cbde727c2cfafb"
    sha256 ventura:       "57f7bb2c6461df6ec4bf1d3bdf1a3b9f7c8418d028133e3fe1ef0a6352d838d4"
    sha256 x86_64_linux:  "6e47df7368dfa9c860f1b8f5474565029f7976e62e679955f870527155aa2799"
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