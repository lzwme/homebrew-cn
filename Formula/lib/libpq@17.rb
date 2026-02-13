class LibpqAT17 < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/17/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v17.8/postgresql-17.8.tar.bz2"
  sha256 "a88d195dd93730452d0cfa1a11896720d6d1ba084bc2be7d7fc557fa4e4158a0"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(17(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_tahoe:   "5b3493ba48939127b35c9fcee95e49fcfcbc94c8adde6049ce0386145fcdd579"
    sha256 arm64_sequoia: "b15acd88a84a331b473abfd0ae1b102dbb43c33989535cfcbfbcba0183d31c20"
    sha256 arm64_sonoma:  "a0bb49a5b8a2e2810e6a580a0b70e42c0d2a16d180a51b3da31f78a19e766f01"
    sha256 sonoma:        "6a651b2d024f986f4de69897d0356e0ba83c098cbfc118c6f3867b4a31f341b1"
    sha256 arm64_linux:   "7957bd47758273bb2084177ad0c6adf5798f73e1c292eafc5b78d176ac4b185d"
    sha256 x86_64_linux:  "7f70b2b48d05f08ca9dbc978ee124ceb670f986e3d7c65ea77776214c615ab61"
  end

  keg_only :versioned_formula

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
  uses_from_macos "zlib"

  on_linux do
    depends_on "readline"
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