class Alpine < Formula
  desc "News and email agent"
  homepage "https:alpineapp.email"
  url "https:alpineapp.emailalpinereleasesrcalpine-2.26.tar.xz"
  # keep mirror even though `brew audit --strict --online` complains
  mirror "https:alpineapp.emailalpinereleasesrcOldalpine-2.26.tar.xz"
  sha256 "c0779c2be6c47d30554854a3e14ef5e36539502b331068851329275898a9baba"
  license "Apache-2.0"
  head "https:repo.or.czalpine.git", branch: "master"

  livecheck do
    url :homepage
    regex(href=.*?alpine[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 arm64_sequoia:  "0299b3f80c9193359059909396ebf74078a263d0e0987e086741398bac68d566"
    sha256 arm64_sonoma:   "7ad58b222ed8fa4ef1a7609c1223796de0a349d3d5b408109c408793586dfee5"
    sha256 arm64_ventura:  "9b7a5da6cd88ce590ec0c1c2ef8dc45da8a4fa45d108eb976157ddd505cf2b2a"
    sha256 arm64_monterey: "b1c884c5cc1d84813284e85e74ae3c78db147b46da0d0b8d18ade4ff2ee550ac"
    sha256 arm64_big_sur:  "ba5962d03c0733fff29eb92d1c759867185d38de7ba342561ccbd20da5ce050d"
    sha256 sonoma:         "a7e085c449b40a91ecba38010375fd7f4ad9446c0a2cd490ed2dbf3da2b06f67"
    sha256 ventura:        "7b8f62b0200eb3ed18c3f79ecf7201f8409916f505fe738068307b6dbeb754ca"
    sha256 monterey:       "5f289262fe8971acbe473b036316f73d7a17c8f9bbbcb7a966c2a2d5e7c06ee6"
    sha256 big_sur:        "8a5830644c5e7738ba52ad6687eebf493020c8e6d14a4d247b3372138cac37a3"
    sha256 catalina:       "0a9ccb4fa8aac9476933d439ee57c30c234a20c0b189cdab09dfceba2e19b00d"
    sha256 arm64_linux:    "26792044eea71951e4a6236711a8f29cb7e52e68ee289cac3c809815bbd484be"
    sha256 x86_64_linux:   "3a326ae9048a1ea6fe4403478254a7bb403c1a565486b96d7224138f1b2e3072"
  end

  depends_on "openssl@3"

  uses_from_macos "krb5"
  uses_from_macos "ncurses"
  uses_from_macos "openldap"

  on_linux do
    depends_on "linux-pam"
  end

  conflicts_with "imap-uw", because: "both install `mailutil` binaries"
  conflicts_with "macpine", because: "both install `alpine` binaries"

  # patch for macOS obtained from developer; see git commit
  # https:repo.or.czalpine.gitcommitdiff701aebc00aff0585ce6c96653714e4ba94834c9c
  patch :DATA
  # fix `error: incompatible function pointer types`
  patch do
    url "https:raw.githubusercontent.comgentoogentoo37cdeedd76ed2f1f9d169431ac98c9e40afe9372mail-clientalpinefilesalpine-2.26-fix-clang16-build-no-chappa.patch"
    sha256 "0e51e8253f9e5ff7fc9599845ec2bd3a0007a1bffb097a603dfd8d6fa6362797"
  end

  def install
    ENV.deparallelize

    args = %W[
      --disable-debug
      --with-ssl-dir=#{Formula["openssl@3"].opt_prefix}
      --with-ssl-certs-dir=#{etc}openssl@3
      --prefix=#{prefix}
      --with-bundled-tools
    ]

    system ".configure", *args
    system "make", "install"
  end

  test do
    system bin"alpine", "-conf"
  end
end

__END__
--- aconfigure
+++ bconfigure
@@ -18752,6 +18752,26 @@
 fi
 
 
+
+# Check whether --with-local-password-cache was given.
+if test "${with_local_password_cache+set}" = set; then :
+  withval=$with_local_password_cache;
+     alpine_os_credential_cache=$withval
+
+fi
+
+
+
+# Check whether --with-local-password-cache-method was given.
+if test "${with_local_password_cache_method+set}" = set; then :
+  withval=$with_local_password_cache_method;
+     alpine_os_credential_cache_method=$withval
+
+fi
+
+
+alpine_cache_os_method="no"
+
 alpine_PAM="none"
 
 case "$host" in
@@ -18874,6 +18894,7 @@
 
 $as_echo "#define APPLEKEYCHAIN 1" >>confdefs.h
 
+	alpine_cache_os_method="yes"
 	;;
     esac
     if test -z "$alpine_c_client_bundled" ; then
@@ -19096,25 +19117,7 @@
 
 
 
-
-# Check whether --with-local-password-cache was given.
-if test "${with_local_password_cache+set}" = set; then :
-  withval=$with_local_password_cache;
-     alpine_os_credential_cache=$withval
-
-fi
-
-
-
-# Check whether --with-local-password-cache-method was given.
-if test "${with_local_password_cache_method+set}" = set; then :
-  withval=$with_local_password_cache_method;
-     alpine_os_credential_cache_method=$withval
-
-fi
-
-
-if test -z "$alpine_PASSFILE" ; then
+if test -z "$alpine_PASSFILE" -a "alpine_cache_os_method" = "no" ; then
   if test -z "$alpine_SYSTEM_PASSFILE" ; then
      alpine_PASSFILE=".alpine.pwd"
   else
@@ -25365,4 +25368,3 @@
   { $as_echo "$as_me:${as_lineno-$LINENO}: WARNING: unrecognized options: $ac_unrecognized_opts" >&5
 $as_echo "$as_me: WARNING: unrecognized options: $ac_unrecognized_opts" >&2;}
 fi
-