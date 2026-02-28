class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/current/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v18.3/postgresql-18.3.tar.bz2"
  sha256 "d95663fbbf3a80f81a9d98d895266bdcb74ba274bcc04ef6d76630a72dee016f"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_tahoe:   "78053e68539ec313674b4e05b98a309cb8802b4f8cfabddaa5d6b4b14c50a14a"
    sha256 arm64_sequoia: "776e26d187ee97c5630885210c735b5dbd59033a66e8d25e074feccd3e7b75cd"
    sha256 arm64_sonoma:  "41df03774ddd2c81f325e0a0e67589925165e5be7fc89cdc6662150ece975523"
    sha256 sonoma:        "b56835b21500f3032b2e25adefed176497ca53901dd8f9ea3c0262cec44c7639"
    sha256 arm64_linux:   "39bac453617bcdb345f1b19dd26ec37a5dd254e5b50973f08371fe718d510be5"
    sha256 x86_64_linux:  "39b9666ddf72ecc12118ec1803d3f4d11d3324f96329aba184bc77ab4a8a0edf"
  end

  keg_only "it conflicts with PostgreSQL"

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@78"
  # GSSAPI provided by Kerberos.framework crashes when forked.
  # See https://github.com/Homebrew/homebrew-core/issues/47494.
  depends_on "krb5"
  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libxml2" => :build
  uses_from_macos "libxslt" => :build # for xsltproc

  on_linux do
    depends_on "readline"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    ENV.runtime_cpu_detection

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-gssapi",
                          "--with-openssl",
                          "--libdir=#{opt_lib}",
                          "--includedir=#{opt_include}"
    dirs = %W[
      libdir=#{lib}
      includedir=#{include}
      pkgincludedir=#{include}/postgresql
      includedir_server=#{include}/postgresql/server
      includedir_internal=#{include}/postgresql/internal
    ]
    system "make"
    system "make", "-C", "src/bin", "install", *dirs
    system "make", "-C", "src/include", "install", *dirs
    system "make", "-C", "src/interfaces", "install", *dirs
    system "make", "-C", "src/common", "install", *dirs
    system "make", "-C", "src/port", "install", *dirs
    system "make", "-C", "doc", "install", *dirs
  end

  test do
    (testpath/"libpq.c").write <<~C
      #include <stdlib.h>
      #include <stdio.h>
      #include <libpq-fe.h>

      int main()
      {
          const char *conninfo;
          PGconn     *conn;

          conninfo = "dbname = postgres";

          conn = PQconnectdb(conninfo);

          if (PQstatus(conn) != CONNECTION_OK) // This should always fail
          {
              printf("Connection to database attempted and failed");
              PQfinish(conn);
              exit(0);
          }

          return 0;
        }
    C
    system ENV.cc, "libpq.c", "-L#{lib}", "-I#{include}", "-lpq", "-o", "libpqtest"
    assert_equal "Connection to database attempted and failed", shell_output("./libpqtest")
  end
end