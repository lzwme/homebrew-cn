class PhpAT70Zts < Formula
  desc "General-purpose scripting language"
  homepage "https:secure.php.net"
  url "https:github.comshivammathurphp-src-backportsarchivee74d83cb136282e1fda676bf22a7cc7f5578626b.tar.gz"
  version "7.0.33"
  sha256 "a40f969f584fb35b1caf1d2f5c45dfceee92f7e9d8e61b26b806f7537c5c645b"
  license "PHP-3.01"
  revision 4

  bottle do
    root_url "https:ghcr.iov2shivammathurphp"
    sha256 arm64_sequoia: "40ac67cd7c477d1d76007af2d6884060d060145ac962974ed9030174631ef23d"
    sha256 arm64_sonoma:  "cce11abad7a78a3da4b4f55dde4ed59312dfed360d6c83811acb93040c7988c7"
    sha256 arm64_ventura: "559b15088dc0ca85d16227ef8c242ccd8c51ca63a24662e725ea66df00ed5f09"
    sha256 ventura:       "1831a213eea2d89dbd831c2feb8b7ded542418e40536d00981a041d25da9a98a"
    sha256 x86_64_linux:  "6eb37e443e406b66e276e588142ef2810cdc9100a4726e1fef4d33aab5704452"
  end

  keg_only :versioned_formula

  # This PHP version is not supported upstream as of 2019-01-10.
  # Although, this was built with back-ported security patches,
  # we recommended to use a currently supported PHP version.
  # For more details, refer to https:www.php.neteol.php
  deprecate! date: "2019-01-10", because: :deprecated_upstream

  depends_on "bison" => :build
  depends_on "httpd" => [:build, :test]
  depends_on "pkgconf" => :build
  depends_on "re2c" => :build
  depends_on "apr"
  depends_on "apr-util"
  depends_on "aspell"
  depends_on "autoconf"
  depends_on "curl"
  depends_on "freetds"
  depends_on "freetype"
  depends_on "gd"
  depends_on "gettext"
  depends_on "gmp"
  depends_on "icu4c@76"
  depends_on "jpeg"
  depends_on "krb5"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "libtool"
  depends_on "libx11"
  depends_on "libxpm"
  depends_on "libzip"
  depends_on "openldap"
  depends_on "openssl@3"
  depends_on "pcre"
  depends_on "sqlite"
  depends_on "tidy-html5"
  depends_on "unixodbc"
  depends_on "webp"

  uses_from_macos "bzip2"
  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  on_macos do
    # PHP build system incorrectly links system libraries
    patch :DATA
  end

  def install
    # Work around configure issues with Xcode 12
    # See https:bugs.php.netbug.php?id=80171
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

    # Work around for building with Xcode 15.3
    if DevelopmentTools.clang_build_version >= 1500
      ENV.append "CFLAGS", "-Wno-incompatible-function-pointer-types"
      ENV.append "LDFLAGS", "-lresolv"
      inreplace "mainreentrancy.c", "readdir_r(dirp, entry)", "readdir_r(dirp, entry, result)"
    end

    # icu4c 61.1 compatibility
    ENV.append "CPPFLAGS", "-DU_USING_ICU_NAMESPACE=1"

    # Workaround for https:bugs.php.net80310
    ENV.append "CFLAGS", "-DU_DEFINE_FALSE_AND_TRUE=1"
    ENV.append "CXXFLAGS", "-DU_DEFINE_FALSE_AND_TRUE=1"

    # Work around to support `icu4c` 75, which needs C++17.
    ENV.append "CXX", "-std=c++17"
    ENV.libcxx if ENV.compiler == :clang

    # buildconf required due to system library linking bug patch
    system ".buildconf", "--force"

    inreplace "configure" do |s|
      s.gsub! "APACHE_THREADED_MPM=`$APXS_HTTPD -V | grep 'threaded:.*yes'`",
              "APACHE_THREADED_MPM="
      s.gsub! "APXS_LIBEXECDIR='$(INSTALL_ROOT)'`$APXS -q LIBEXECDIR`",
              "APXS_LIBEXECDIR='$(INSTALL_ROOT)#{lib}httpdmodules'"
      s.gsub! "-z `$APXS -q SYSCONFDIR`",
              "-z ''"
      # apxs will interpolate the @ in the versioned prefix: https:bz.apache.orgbugzillashow_bug.cgi?id=61944
      s.gsub! "LIBEXECDIR='$APXS_LIBEXECDIR'",
              "LIBEXECDIR='" + "#{lib}httpdmodules".gsub("@", "\\@") + "'"
    end

    # Update error message in apache sapi to better explain the requirements
    # of using Apache http in combination with php if the non-compatible MPM
    # has been selected. Homebrew has chosen not to support being able to
    # compile a thread safe version of PHP and therefore it is not
    # possible to recompile as suggested in the original message
    inreplace "sapiapache2handlersapi_apache2.c",
              "You need to recompile PHP.",
              "Homebrew PHP does not support a thread-safe php binary. " \
              "To use the PHP apache sapi please change " \
              "your httpd config to use the prefork MPM"

    inreplace "sapifpmphp-fpm.conf.in", ";daemonize = yes", "daemonize = no"

    # API compatibility with tidy-html5 v5.0.0 - https:github.comhtacgtidy-html5issues224
    inreplace "exttidytidy.c", "buffio.h", "tidybuffio.h"

    config_path = etc"php#{php_version}"
    # Prevent system pear config from inhibiting pear install
    (config_path"pear.conf").delete if (config_path"pear.conf").exist?

    # Prevent homebrew from hardcoding path to sed shim in phpize script
    ENV["lt_cv_path_SED"] = "sed"

    # Each extension that is built on Mojave needs a direct reference to the
    # sdk path or it won't find the headers
    headers_path = "=#{MacOS.sdk_path_if_needed}usr" if OS.mac?

    # `_www` only exists on macOS.
    fpm_user = OS.mac? ? "_www" : "www-data"
    fpm_group = OS.mac? ? "_www" : "www-data"

    args = %W[
      --prefix=#{prefix}
      --localstatedir=#{var}
      --sysconfdir=#{config_path}
      --with-config-file-path=#{config_path}
      --with-config-file-scan-dir=#{config_path}conf.d
      --with-pear=#{pkgshare}pear
      --disable-zend-signals
      --enable-bcmath
      --enable-calendar
      --enable-dba
      --enable-exif
      --enable-ftp
      --enable-fpm
      --enable-intl
      --enable-maintainer-zts
      --enable-mbregex
      --enable-mbstring
      --enable-mysqlnd
      --enable-opcache-file
      --enable-pcntl
      --enable-phpdbg
      --enable-phpdbg-webhelper
      --enable-shmop
      --enable-soap
      --enable-sockets
      --enable-sysvmsg
      --enable-sysvsem
      --enable-sysvshm
      --enable-wddx
      --enable-zip
      --with-apxs2=#{Formula["httpd"].opt_bin}apxs
      --with-curl=#{Formula["curl"].opt_prefix}
      --with-fpm-user=#{fpm_user}
      --with-fpm-group=#{fpm_group}
      --with-freetype-dir=#{Formula["freetype"].opt_prefix}
      --with-gd=#{Formula["gd"].opt_prefix}
      --with-gettext=#{Formula["gettext"].opt_prefix}
      --with-gmp=#{Formula["gmp"].opt_prefix}
      --with-iconv#{headers_path}
      --with-icu-dir=#{Formula["icu4c@76"].opt_prefix}
      --with-jpeg-dir=#{Formula["jpeg"].opt_prefix}
      --with-kerberos#{headers_path}
      --with-layout=GNU
      --with-ldap=#{Formula["openldap"].opt_prefix}
      --with-ldap-sasl#{headers_path}
      --with-libzip
      --with-mhash#{headers_path}
      --with-mysql-sock=tmpmysql.sock
      --with-mysqli=mysqlnd
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
      --with-pdo-dblib=#{Formula["freetds"].opt_prefix}
      --with-pdo-mysql=mysqlnd
      --with-pdo-odbc=unixODBC,#{Formula["unixodbc"].opt_prefix}
      --with-pdo-pgsql=#{Formula["libpq"].opt_prefix}
      --with-pdo-sqlite=#{Formula["sqlite"].opt_prefix}
      --with-pgsql=#{Formula["libpq"].opt_prefix}
      --with-pic
      --with-png-dir=#{Formula["libpng"].opt_prefix}
      --with-pspell=#{Formula["aspell"].opt_prefix}
      --with-sqlite3=#{Formula["sqlite"].opt_prefix}
      --with-tidy=#{Formula["tidy-html5"].opt_prefix}
      --with-unixODBC=#{Formula["unixodbc"].opt_prefix}
      --with-webp-dir=#{Formula["webp"].opt_prefix}
      --with-xmlrpc
      --with-xpm-dir=#{Formula["libxpm"].opt_prefix}
    ]

    if OS.mac?
      args << "--enable-dtrace"
      args << "--with-bz2#{headers_path}"
      args << "--with-libedit#{headers_path}"
      args << "--with-libxml-dir#{headers_path}"
      args << "--with-ndbm#{headers_path}"
      args << "--with-xsl#{headers_path}"
      args << "--with-zlib#{headers_path}"
    else
      args << "--disable-dtrace"
      args << "--with-zlib=#{Formula["zlib"].opt_prefix}"
      args << "--with-bzip2=#{Formula["bzip2"].opt_prefix}"
      args << "--with-libedit=#{Formula["libedit"].opt_prefix}"
      args << "--with-libxml-dir=#{Formula["libxml2"].opt_prefix}"
      args << "--with-xsl=#{Formula["libxslt"].opt_prefix}"
      args << "--without-ldap-sasl"
      args << "--without-ndbm"
      args << "--without-gdbm"
    end

    system ".configure", *args
    system "make"
    system "make", "install"

    # Allow pecl to install outside of Cellar
    extension_dir = Utils.safe_popen_read("#{bin}php-config", "--extension-dir").chomp
    orig_ext_dir = File.basename(extension_dir)
    inreplace bin"php-config", lib"php", prefix"pecl"
    %w[development production].each do |mode|
      inreplace "php.ini-#{mode}", %r{; ?extension_dir = "\."},
        "extension_dir = \"#{HOMEBREW_PREFIX}libphppecl#{orig_ext_dir}\""
    end

    # Use OpenSSL cert bundle
    openssl = Formula["openssl@3"]
    %w[development production].each do |mode|
      inreplace "php.ini-#{mode}", ; ?openssl\.cafile=,
        "openssl.cafile = \"#{openssl.pkgetc}cert.pem\""
      inreplace "php.ini-#{mode}", ; ?openssl\.capath=,
        "openssl.capath = \"#{openssl.pkgetc}certs\""
    end

    config_files = {
      "php.ini-development"   => "php.ini",
      "php.ini-production"    => "php.ini-production",
      "sapifpmphp-fpm.conf" => "php-fpm.conf",
      "sapifpmwww.conf"     => "php-fpm.dwww.conf",
    }
    config_files.each_value do |dst|
      dst_default = config_path"#{dst}.default"
      rm dst_default if dst_default.exist?
    end
    config_path.install config_files

    unless (var"logphp-fpm.log").exist?
      (var"log").mkpath
      touch var"logphp-fpm.log"
    end
  end

  def post_install
    pear_prefix = pkgshare"pear"
    pear_files = %W[
      #{pear_prefix}.depdblock
      #{pear_prefix}.filemap
      #{pear_prefix}.depdb
      #{pear_prefix}.lock
    ]

    %W[
      #{pear_prefix}.channels
      #{pear_prefix}.channels.alias
    ].each do |f|
      chmod 0755, f
      pear_files.concat(Dir["#{f}*"])
    end

    chmod 0644, pear_files

    # Custom location for extensions installed via pecl
    pecl_path = HOMEBREW_PREFIX"libphppecl"
    pecl_path.mkpath
    ln_s pecl_path, prefix"pecl" unless (prefix"pecl").exist?
    extension_dir = Utils.safe_popen_read("#{bin}php-config", "--extension-dir").chomp
    php_basename = File.basename(extension_dir)
    php_ext_dir = opt_prefix"libphp"php_basename

    # fix pear config to install outside cellar
    pear_path = HOMEBREW_PREFIX"sharepear@#{php_version}"
    cp_r pkgshare"pear.", pear_path
    {
      "php_ini"  => etc"php#{php_version}php.ini",
      "php_dir"  => pear_path,
      "doc_dir"  => pear_path"doc",
      "ext_dir"  => pecl_pathphp_basename,
      "bin_dir"  => opt_bin,
      "data_dir" => pear_path"data",
      "cfg_dir"  => pear_path"cfg",
      "www_dir"  => pear_path"htdocs",
      "man_dir"  => HOMEBREW_PREFIX"shareman",
      "test_dir" => pear_path"test",
      "php_bin"  => opt_bin"php",
    }.each do |key, value|
      value.mkpath if (?<!bin|man)_dir$.match?(key)
      system bin"pear", "config-set", key, value, "system"
    end

    system bin"pear", "update-channels"

    %w[
      opcache
    ].each do |e|
      ext_config_path = etc"php#{php_version}conf.dext-#{e}.ini"
      extension_type = (e == "opcache") ? "zend_extension" : "extension"
      if ext_config_path.exist?
        inreplace ext_config_path,
          #{extension_type}=.*$, "#{extension_type}=#{php_ext_dir}#{e}.so"
      else
        ext_config_path.write <<~EOS
          [#{e}]
          #{extension_type}="#{php_ext_dir}#{e}.so"
        EOS
      end
    end
  end

  def caveats
    <<~EOS
      To enable PHP in Apache add the following to httpd.conf and restart Apache:
          LoadModule php7_module #{opt_lib}httpdmoduleslibphp7.so

          <FilesMatch \\.php$>
              SetHandler applicationx-httpd-php
          <FilesMatch>

      Finally, check DirectoryIndex includes index.php
          DirectoryIndex index.php index.html

      The php.ini and php-fpm.ini file can be found in:
          #{etc}php#{php_version}
    EOS
  end

  def php_version
    version.to_s.split(".")[0..1].join(".") + "-zts"
  end

  service do
    run [opt_sbin"php-fpm", "--nodaemonize"]
    run_type :immediate
    keep_alive true
    error_log_path var"logphp-fpm.log"
    working_dir var
  end

  test do
    assert_match(^Zend OPcache$, shell_output("#{bin}php -i"),
      "Zend OPCache extension not loaded")
    # Test related to libxml2 and
    # https:github.comHomebrewhomebrew-coreissues28398
    assert_includes (bin"php").dynamically_linked_libraries,
                    (Formula["libpq"].opt_libshared_library("libpq", 5)).to_s

    system "#{sbin}php-fpm", "-t"
    system "#{bin}phpdbg", "-V"
    system "#{bin}php-cgi", "-m"
    # Prevent SNMP extension to be added
    refute_match(^snmp$, shell_output("#{bin}php -m"),
      "SNMP extension doesn't work reliably with Homebrew on High Sierra")
    begin
      port = free_port
      port_fpm = free_port

      expected_output = ^Hello world!$
      (testpath"index.php").write <<~EOS
        <?php
        echo 'Hello world!' . PHP_EOL;
        var_dump(ldap_connect());
      EOS
      main_config = <<~EOS
        Listen #{port}
        ServerName localhost:#{port}
        DocumentRoot "#{testpath}"
        ErrorLog "#{testpath}httpd-error.log"
        ServerRoot "#{Formula["httpd"].opt_prefix}"
        PidFile "#{testpath}httpd.pid"
        LoadModule authz_core_module libhttpdmodulesmod_authz_core.so
        LoadModule unixd_module libhttpdmodulesmod_unixd.so
        LoadModule dir_module libhttpdmodulesmod_dir.so
        DirectoryIndex index.php
      EOS

      (testpath"httpd.conf").write <<~EOS
        #{main_config}
        LoadModule mpm_prefork_module libhttpdmodulesmod_mpm_prefork.so
        LoadModule php7_module #{lib}httpdmoduleslibphp7.so
        <FilesMatch \\.(php|phar)$>
          SetHandler applicationx-httpd-php
        <FilesMatch>
      EOS

      (testpath"fpm.conf").write <<~EOS
        [global]
        daemonize=no
        [www]
        listen = 127.0.0.1:#{port_fpm}
        pm = dynamic
        pm.max_children = 5
        pm.start_servers = 2
        pm.min_spare_servers = 1
        pm.max_spare_servers = 3
      EOS

      (testpath"httpd-fpm.conf").write <<~EOS
        #{main_config}
        LoadModule mpm_event_module libhttpdmodulesmod_mpm_event.so
        LoadModule proxy_module libhttpdmodulesmod_proxy.so
        LoadModule proxy_fcgi_module libhttpdmodulesmod_proxy_fcgi.so
        <FilesMatch \\.(php|phar)$>
          SetHandler "proxy:fcgi:127.0.0.1:#{port_fpm}"
        <FilesMatch>
      EOS

      pid = fork do
        exec Formula["httpd"].opt_bin"httpd", "-X", "-f", "#{testpath}httpd.conf"
      end
      sleep 3

      assert_match expected_output, shell_output("curl -s 127.0.0.1:#{port}")

      Process.kill("TERM", pid)
      Process.wait(pid)

      fpm_pid = fork do
        exec sbin"php-fpm", "-y", "fpm.conf"
      end
      pid = fork do
        exec Formula["httpd"].opt_bin"httpd", "-X", "-f", "#{testpath}httpd-fpm.conf"
      end
      sleep 3

      assert_match expected_output, shell_output("curl -s 127.0.0.1:#{port}")
    ensure
      if pid
        Process.kill("TERM", pid)
        Process.wait(pid)
      end
      if fpm_pid
        Process.kill("TERM", fpm_pid)
        Process.wait(fpm_pid)
      end
    end
  end
end

__END__
diff --git aconfigure.in bconfigure.in
index 7ba3bc05a5..279230fa80 100644
--- aconfigure.in
+++ bconfigure.in
@@ -60,7 +60,13 @@ AH_BOTTOM([
 #endif

 #if ZEND_BROKEN_SPRINTF
+#ifdef __cplusplus
+extern "C" {
+#endif
 int zend_sprintf(char *buffer, const char *format, ...);
+#ifdef __cplusplus
+}
+#endif
 #else
 # define zend_sprintf sprintf
 #endif
diff --git aacinclude.m4 bacinclude.m4
index 168c465f8d..6c087d152f 100644
--- aacinclude.m4
+++ bacinclude.m4
@@ -441,7 +441,11 @@ dnl
 dnl Adds a path to linkpathrunpath (LDFLAGS)
 dnl
 AC_DEFUN([PHP_ADD_LIBPATH],[
-  if test "$1" != "usr$PHP_LIBDIR" && test "$1" != "usrlib"; then
+  case "$1" in
+  "usr$PHP_LIBDIR"|"usrlib"[)] ;;
+  LibraryDeveloperCommandLineToolsSDKs*usrlib[)] ;;
+  ApplicationsXcode*.appContentsDeveloperPlatformsMacOSX.platformDeveloperSDKs*usrlib[)] ;;
+  *[)]
     PHP_EXPAND_PATH($1, ai_p)
     ifelse([$2],,[
       _PHP_ADD_LIBPATH_GLOBAL([$ai_p])
@@ -452,8 +456,8 @@ AC_DEFUN([PHP_ADD_LIBPATH],[
       else
         _PHP_ADD_LIBPATH_GLOBAL([$ai_p])
       fi
-    ])
-  fi
+    ]) ;;
+  esac
 ])

 dnl
@@ -487,7 +491,11 @@ dnl add an include path.
 dnl if before is 1, add in the beginning of INCLUDES.
 dnl
 AC_DEFUN([PHP_ADD_INCLUDE],[
-  if test "$1" != "usrinclude"; then
+  case "$1" in
+  "usrinclude"[)] ;;
+  LibraryDeveloperCommandLineToolsSDKs*usrinclude[)] ;;
+  ApplicationsXcode*.appContentsDeveloperPlatformsMacOSX.platformDeveloperSDKs*usrinclude[)] ;;
+  *[)]
     PHP_EXPAND_PATH($1, ai_p)
     PHP_RUN_ONCE(INCLUDEPATH, $ai_p, [
       if test "$2"; then
@@ -495,8 +503,8 @@ AC_DEFUN([PHP_ADD_INCLUDE],[
       else
         INCLUDES="$INCLUDES -I$ai_p"
       fi
-    ])
-  fi
+    ]) ;;
+  esac
 ])

 dnl internal, don't use
@@ -2411,7 +2419,8 @@ AC_DEFUN([PHP_SETUP_ICONV], [
     fi

     if test -f $ICONV_DIR$PHP_LIBDIRlib$iconv_lib_name.a ||
-       test -f $ICONV_DIR$PHP_LIBDIRlib$iconv_lib_name.$SHLIB_SUFFIX_NAME
+       test -f $ICONV_DIR$PHP_LIBDIRlib$iconv_lib_name.$SHLIB_SUFFIX_NAME ||
+       test -f $ICONV_DIR$PHP_LIBDIRlib$iconv_lib_name.tbd
     then
       PHP_CHECK_LIBRARY($iconv_lib_name, libiconv, [
         found_iconv=yes