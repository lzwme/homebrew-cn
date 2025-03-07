class PhpAT85Debug < Formula
  desc "General-purpose scripting language"
  homepage "https:www.php.net"
  url "https:github.comphpphp-srcarchivecd586623b65c86b423883eda20411634e49084ba.tar.gz?commit=cd586623b65c86b423883eda20411634e49084ba"
  version "8.5.0"
  sha256 "c1a53dd93b6a3d17eb3158391dacb53b3596f636d5953879fb24e82d46217cdc"
  license "PHP-3.01"
  revision 2

  bottle do
    root_url "https:ghcr.iov2shivammathurphp"
    rebuild 57
    sha256 arm64_sequoia: "86385083deae14ea66a332c71c0c20e4af5eed267ad77ec732a6b74efbbe64df"
    sha256 arm64_sonoma:  "506d9d481d73423069753131a8f50524286687b1d107928d97f93bfd7750d844"
    sha256 arm64_ventura: "d02aff608b33c28c550e9edfd48ee5d6b9446ce2b853dff8f1e764a03a938924"
    sha256 ventura:       "4e801ac87bb56705d9ea023fca32404a88d9f18a0cba82db45246ae28bba4bf7"
    sha256 x86_64_linux:  "2ae06d18683e42e7606b365985580c6f1e368fb9473f27b4250b79ce0ea5c80c"
  end

  keg_only :versioned_formula

  depends_on "bison" => :build
  depends_on "httpd" => [:build, :test]
  depends_on "pkgconf" => :build
  depends_on "re2c" => :build
  depends_on "apr"
  depends_on "apr-util"
  depends_on "argon2"
  depends_on "aspell"
  depends_on "autoconf"
  depends_on "capstone"
  depends_on "curl"
  depends_on "freetds"
  depends_on "gd"
  depends_on "gettext"
  depends_on "gmp"
  depends_on "icu4c@76"
  depends_on "krb5"
  depends_on "libpq"
  depends_on "libsodium"
  depends_on "libzip"
  depends_on "oniguruma"
  depends_on "openldap"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "sqlite"
  depends_on "tidy-html5"
  depends_on "unixodbc"

  uses_from_macos "bzip2"
  uses_from_macos "libedit"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  on_macos do
    # PHP build system incorrectly links system libraries
    patch :DATA
  end

  def install
    # buildconf required due to system library linking bug patch
    system ".buildconf", "--force"

    inreplace "configure" do |s|
      s.gsub! "$APXS_HTTPD -V 2>devnull | grep 'threaded:.*yes' >devnull 2>&1",
              "false"
      s.gsub! "APXS_LIBEXECDIR='$(INSTALL_ROOT)'$($APXS -q LIBEXECDIR)",
              "APXS_LIBEXECDIR='$(INSTALL_ROOT)#{lib}httpdmodules'"
      s.gsub! "-z $($APXS -q SYSCONFDIR)",
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

    config_path = etc"php#{php_version}"
    # Prevent system pear config from inhibiting pear install
    (config_path"pear.conf").delete if (config_path"pear.conf").exist?

    # Prevent homebrew from hardcoding path to sed shim in phpize script
    ENV["lt_cv_path_SED"] = "sed"

    # Identify build provider in php -v output and phpinfo()
    ENV["PHP_BUILD_PROVIDER"] = "Shivam Mathur"

    # system pkg-config missing
    ENV["KERBEROS_CFLAGS"] = " "
    if OS.mac?
      ENV["SASL_CFLAGS"] = "-I#{MacOS.sdk_path_if_needed}usrincludesasl"
      ENV["SASL_LIBS"] = "-lsasl2"
    else
      ENV["SQLITE_CFLAGS"] = "-I#{Formula["sqlite"].opt_include}"
      ENV["SQLITE_LIBS"] = "-lsqlite3"
      ENV["BZIP_DIR"] = Formula["bzip2"].opt_prefix
    end

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
      --enable-bcmath
      --enable-calendar
      --enable-dba
      --enable-debug
      --enable-exif
      --enable-ftp
      --enable-fpm
      --enable-gd
      --enable-intl
      --enable-mbregex
      --enable-mbstring
      --enable-mysqlnd
      --enable-opcache
      --enable-pcntl
      --enable-phpdbg
      --enable-phpdbg-readline
      --enable-phpdbg-webhelper
      --enable-shmop
      --enable-soap
      --enable-sockets
      --enable-sysvmsg
      --enable-sysvsem
      --enable-sysvshm
      --with-apxs2=#{Formula["httpd"].opt_bin}apxs
      --with-bz2#{headers_path}
      --with-capstone
      --with-curl
      --with-external-gd
      --with-external-pcre
      --with-ffi
      --with-fpm-user=#{fpm_user}
      --with-fpm-group=#{fpm_group}
      --with-gettext=#{Formula["gettext"].opt_prefix}
      --with-gmp=#{Formula["gmp"].opt_prefix}
      --with-iconv#{headers_path}
      --with-kerberos
      --with-layout=GNU
      --with-ldap=#{Formula["openldap"].opt_prefix}
      --with-libxml
      --with-libedit
      --with-mhash#{headers_path}
      --with-mysql-sock=tmpmysql.sock
      --with-mysqli=mysqlnd
      --with-ndbm#{headers_path}
      --with-openssl
      --with-password-argon2
      --with-pdo-dblib=#{Formula["freetds"].opt_prefix}
      --with-pdo-mysql=mysqlnd
      --with-pdo-odbc=unixODBC,#{Formula["unixodbc"].opt_prefix}
      --with-pdo-pgsql=#{Formula["libpq"].opt_prefix}
      --with-pdo-sqlite
      --with-pgsql=#{Formula["libpq"].opt_prefix}
      --with-pic
      --with-pspell=#{Formula["aspell"].opt_prefix}
      --with-sodium
      --with-sqlite3
      --with-tidy=#{Formula["tidy-html5"].opt_prefix}
      --with-unixODBC
      --with-xsl
      --with-zip
      --with-zlib
    ]

    if OS.mac?
      args << "--enable-dtrace"
      args << "--with-ldap-sasl"
      args << "--with-os-sdkpath=#{MacOS.sdk_path_if_needed}"
    else
      args << "--disable-dtrace"
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
          LoadModule php_module #{opt_lib}httpdmoduleslibphp.so

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
    version.to_s.split(".")[0..1].join(".") + "-debug"
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
        LoadModule php_module #{lib}httpdmoduleslibphp.so
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
diff --git ascriptsphp-config.in bscriptsphp-config.in
index 87c20089bb..879299f9cf 100644
--- ascriptsphp-config.in
+++ bscriptsphp-config.in
@@ -11,7 +11,7 @@ lib_dir="@orig_libdir@"
 includes="-I$include_dir -I$include_dirmain -I$include_dirTSRM -I$include_dirZend -I$include_dirext -I$include_dirextdatelib"
 ldflags="@PHP_LDFLAGS@"
 libs="@EXTRA_LIBS@"
-extension_dir="@EXTENSION_DIR@"
+extension_dir='@EXTENSION_DIR@'
 man_dir=`eval echo @mandir@`
 program_prefix="@program_prefix@"
 program_suffix="@program_suffix@"
diff --git abuildphp.m4 bbuildphp.m4
index 176d4d4144..f71d642bb4 100644
--- abuildphp.m4
+++ bbuildphp.m4
@@ -429,7 +429,7 @@ dnl
 dnl Adds a path to linkpathrunpath (LDFLAGS).
 dnl
 AC_DEFUN([PHP_ADD_LIBPATH],[
-  if test "$1" != "usr$PHP_LIBDIR" && test "$1" != "usrlib"; then
+  if test "$1" != "$PHP_OS_SDKPATHusr$PHP_LIBDIR" && test "$1" != "usrlib"; then
     PHP_EXPAND_PATH($1, ai_p)
     ifelse([$2],,[
       _PHP_ADD_LIBPATH_GLOBAL([$ai_p])
@@ -476,7 +476,7 @@ dnl paths are prepended to the beginning of INCLUDES.
 dnl
 AC_DEFUN([PHP_ADD_INCLUDE], [
 for include_path in m4_normalize(m4_expand([$1])); do
-  AS_IF([test "$include_path" != "usrinclude"], [
+  AS_IF([test "$include_path" != "$PHP_OS_SDKPATHusrinclude"], [
     PHP_EXPAND_PATH([$include_path], [ai_p])
     PHP_RUN_ONCE([INCLUDEPATH], [$ai_p], [m4_ifnblank([$2],
       [INCLUDES="-I$ai_p $INCLUDES"],
diff --git aconfigure.ac bconfigure.ac
index 36c6e5e3e2..71b1a16607 100644
--- aconfigure.ac
+++ bconfigure.ac
@@ -190,6 +190,14 @@ PHP_ARG_WITH([libdir],
   [lib],
   [no])

+dnl Support systems with system librariesincludes in e.g. ApplicationsXcode.appContentsDeveloperPlatformsMacOSX.platformDeveloperSDKsMacOSX10.14.sdk.
+PHP_ARG_WITH([os-sdkpath],
+  [for system SDK directory],
+  [AS_HELP_STRING([--with-os-sdkpath=NAME],
+    [Ignore system libraries and includes in NAME rather than ])],
+  [],
+  [no])
+
 PHP_ARG_ENABLE([rpath],
   [whether to enable runpaths],
   [AS_HELP_STRING([--disable-rpath],