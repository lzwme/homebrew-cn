class PostgresqlAT16 < Formula
  desc "Object-relational database system"
  homepage "https:www.postgresql.org"
  url "https:ftp.postgresql.orgpubsourcev16.1postgresql-16.1.tar.bz2"
  sha256 "ce3c4d85d19b0121fe0d3f8ef1fa601f71989e86f8a66f7dc3ad546dd5564fec"
  license "PostgreSQL"
  revision 1

  livecheck do
    url "https:ftp.postgresql.orgpubsource"
    regex(%r{href=["']?v?(16(?:\.\d+)+)?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "0d0232baecc6d937e4b70c33ea1047da1b3a6aaeeb438422ee6b3f088ca4fdfe"
    sha256 arm64_ventura:  "5da5d5aa5687307faf5347dd982de73b1f945909fab3fe31157d87816d1d36d7"
    sha256 arm64_monterey: "be4f99e49fe017e01a803fcbd07b977ce54b8f5ee326b441df51c4d0e76df7e2"
    sha256 sonoma:         "b0fce288cfef6961a4728ed37c953615c1180e2e011c1fe2e4622fa84537e5d5"
    sha256 ventura:        "9ce1f0d41cabf44535ddf83f474636dded2789ee43293289bd3666a6ccf3546c"
    sha256 monterey:       "a27c4e4b2f1ae68581bf9f0ea09362857ee8d958b99b1ae0088d05314beb4297"
    sha256 x86_64_linux:   "5cf57a59b73454e187f16000a015de67603f63e81ff6bc76317c26c08642da1f"
  end

  keg_only :versioned_formula

  # https:www.postgresql.orgsupportversioning
  deprecate! date: "2028-11-09", because: :unsupported

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "icu4c"

  # GSSAPI provided by Kerberos.framework crashes when forked.
  # See https:github.comHomebrewhomebrew-coreissues47494.
  depends_on "krb5"

  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "readline"
  depends_on "zstd"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "openldap"
  uses_from_macos "perl"

  on_linux do
    depends_on "linux-pam"
    depends_on "util-linux"
  end

  # Fix compatibility with OpenSSL 3.2
  # Remove once merged
  # Ref https:www.postgresql.orgmessage-idCX9SU44GH3P4.17X6ZZUJ5D40N%40neon.tech
  patch :DATA

  def install
    ENV.delete "PKG_CONFIG_LIBDIR"
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl@3"].opt_lib} -L#{Formula["readline"].opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl@3"].opt_include} -I#{Formula["readline"].opt_include}"

    # Fix 'libintl.h' file not found for extensions
    ENV.prepend "LDFLAGS", "-L#{Formula["gettext"].opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["gettext"].opt_include}"

    args = std_configure_args + %W[
      --datadir=#{opt_pkgshare}
      --libdir=#{opt_lib}
      --includedir=#{opt_include}
      --sysconfdir=#{etc}
      --docdir=#{doc}
      --enable-nls
      --enable-thread-safety
      --with-gssapi
      --with-icu
      --with-ldap
      --with-libxml
      --with-libxslt
      --with-lz4
      --with-zstd
      --with-openssl
      --with-pam
      --with-perl
      --with-uuid=e2fs
      --with-extra-version=\ (#{tap.user})
    ]
    if OS.mac?
      args += %w[
        --with-bonjour
        --with-tcl
      ]
    end

    # PostgreSQL by default uses xcodebuild internally to determine this,
    # which does not work on CLT-only installs.
    args << "PG_SYSROOT=#{MacOS.sdk_path}" if OS.mac? && MacOS.sdk_root_needed?

    system ".configure", *args

    # Work around busted path magic in Makefile.global.in. This can't be specified
    # in .configure, but needs to be set here otherwise install prefixes containing
    # the string "postgres" will get an incorrect pkglibdir.
    # See https:github.comHomebrewhomebrew-coreissues62930#issuecomment-709411789
    system "make", "pkglibdir=#{opt_lib}postgresql",
                   "pkgincludedir=#{opt_include}postgresql",
                   "includedir_server=#{opt_include}postgresqlserver"
    system "make", "install-world", "datadir=#{pkgshare}",
                                    "libdir=#{lib}",
                                    "pkglibdir=#{lib}postgresql",
                                    "includedir=#{include}",
                                    "pkgincludedir=#{include}postgresql",
                                    "includedir_server=#{include}postgresqlserver",
                                    "includedir_internal=#{include}postgresqlinternal"
  end

  def post_install
    (var"log").mkpath
    postgresql_datadir.mkpath

    # Don't initialize database, it clashes when testing other PostgreSQL versions.
    return if ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "#{bin}initdb", "--locale=C", "-E", "UTF-8", postgresql_datadir unless pg_version_exists?
  end

  def postgresql_datadir
    varname
  end

  def postgresql_log_path
    var"log#{name}.log"
  end

  def pg_version_exists?
    (postgresql_datadir"PG_VERSION").exist?
  end

  def caveats
    <<~EOS
      This formula has created a default database cluster with:
        initdb --locale=C -E UTF-8 #{postgresql_datadir}
      For more details, read:
        https:www.postgresql.orgdocs#{version.major}app-initdb.html
    EOS
  end

  service do
    run [opt_bin"postgres", "-D", f.postgresql_datadir]
    environment_variables LC_ALL: "C"
    keep_alive true
    log_path f.postgresql_log_path
    error_log_path f.postgresql_log_path
    working_dir HOMEBREW_PREFIX
  end

  test do
    system "#{bin}initdb", testpath"test" unless ENV["HOMEBREW_GITHUB_ACTIONS"]
    assert_equal opt_pkgshare.to_s, shell_output("#{bin}pg_config --sharedir").chomp
    assert_equal opt_lib.to_s, shell_output("#{bin}pg_config --libdir").chomp
    assert_equal (opt_lib"postgresql").to_s, shell_output("#{bin}pg_config --pkglibdir").chomp
    assert_equal (opt_include"postgresql").to_s, shell_output("#{bin}pg_config --pkgincludedir").chomp
    assert_equal (opt_include"postgresqlserver").to_s, shell_output("#{bin}pg_config --includedir-server").chomp
    assert_match "-I#{Formula["gettext"].opt_include}", shell_output("#{bin}pg_config --cppflags")
  end
end

__END__
diff --git asrcbackendlibpqbe-secure-openssl.c bsrcbackendlibpqbe-secure-openssl.c
index e9c86d08df..49dca0cda9 100644
--- asrcbackendlibpqbe-secure-openssl.c
+++ bsrcbackendlibpqbe-secure-openssl.c
@@ -844,11 +844,6 @@ be_tls_write(Port *port, void *ptr, size_t len, int *waitfor)
  * to retry; do we need to adopt their logic for that?
  *

-#ifndef HAVE_BIO_GET_DATA
-#define BIO_get_data(bio) (bio->ptr)
-#define BIO_set_data(bio, data) (bio->ptr = data)
-#endif
-
 static BIO_METHOD *my_bio_methods = NULL;

 static int
@@ -858,7 +853,7 @@ my_sock_read(BIO *h, char *buf, int size)

 	if (buf != NULL)
 	{
-		res = secure_raw_read(((Port *) BIO_get_data(h)), buf, size);
+		res = secure_raw_read(((Port *) BIO_get_app_data(h)), buf, size);
 		BIO_clear_retry_flags(h);
 		if (res <= 0)
 		{
@@ -878,7 +873,7 @@ my_sock_write(BIO *h, const char *buf, int size)
 {
 	int			res = 0;

-	res = secure_raw_write(((Port *) BIO_get_data(h)), buf, size);
+	res = secure_raw_write(((Port *) BIO_get_app_data(h)), buf, size);
 	BIO_clear_retry_flags(h);
 	if (res <= 0)
 	{
@@ -954,7 +949,7 @@ my_SSL_set_fd(Port *port, int fd)
 		SSLerr(SSL_F_SSL_SET_FD, ERR_R_BUF_LIB);
 		goto err;
 	}
-	BIO_set_data(bio, port);
+	BIO_set_app_data(bio, port);

 	BIO_set_fd(bio, fd, BIO_NOCLOSE);
 	SSL_set_bio(port->ssl, bio, bio);
diff --git asrcinterfaceslibpqfe-secure-openssl.c bsrcinterfaceslibpqfe-secure-openssl.c
index 390c888c96..b730352b86 100644
--- asrcinterfaceslibpqfe-secure-openssl.c
+++ bsrcinterfaceslibpqfe-secure-openssl.c
@@ -1830,11 +1830,6 @@ PQsslAttribute(PGconn *conn, const char *attribute_name)
  * to retry; do we need to adopt their logic for that?
  *

-#ifndef HAVE_BIO_GET_DATA
-#define BIO_get_data(bio) (bio->ptr)
-#define BIO_set_data(bio, data) (bio->ptr = data)
-#endif
-
 static BIO_METHOD *my_bio_methods;

 static int
@@ -1842,7 +1837,7 @@ my_sock_read(BIO *h, char *buf, int size)
 {
 	int			res;

-	res = pqsecure_raw_read((PGconn *) BIO_get_data(h), buf, size);
+	res = pqsecure_raw_read((PGconn *) BIO_get_app_data(h), buf, size);
 	BIO_clear_retry_flags(h);
 	if (res < 0)
 	{
@@ -1872,7 +1867,7 @@ my_sock_write(BIO *h, const char *buf, int size)
 {
 	int			res;

-	res = pqsecure_raw_write((PGconn *) BIO_get_data(h), buf, size);
+	res = pqsecure_raw_write((PGconn *) BIO_get_app_data(h), buf, size);
 	BIO_clear_retry_flags(h);
 	if (res < 0)
 	{
@@ -1963,7 +1958,7 @@ my_SSL_set_fd(PGconn *conn, int fd)
 		SSLerr(SSL_F_SSL_SET_FD, ERR_R_BUF_LIB);
 		goto err;
 	}
-	BIO_set_data(bio, conn);
+	BIO_set_app_data(bio, conn);

 	SSL_set_bio(conn->ssl, bio, bio);
 	BIO_set_fd(bio, fd, BIO_NOCLOSE);