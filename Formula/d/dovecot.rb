class Dovecot < Formula
  desc "IMAPPOP3 server"
  homepage "https:dovecot.org"
  url "https:dovecot.orgreleases2.4dovecot-2.4.0.tar.gz"
  sha256 "e90e49f8c31b09a508249a4fee8605faa65fe320819bfcadaf2524126253d5ae"
  license all_of: ["BSD-3-Clause", "LGPL-2.1-or-later", "MIT", "Unicode-DFS-2016", :public_domain]

  livecheck do
    url "https:www.dovecot.orgdownload"
    regex(href=.*?dovecot[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "fb2c8f7783e044942d8b5eb322e76478c3a2cf25d017211eca4821b15860996b"
    sha256 arm64_sonoma:  "5418d4d77e0c59b320eb402fee0639afc7489b7d163c748234ebdf97028d6ebe"
    sha256 arm64_ventura: "232e635161c93fb8b8c3bf275dd74c2e57da284d5ccb2b84333c05c70568e4e4"
    sha256 sonoma:        "621962d79e0d1e92d2d8e2f2be0ae3b68d3acb4ddc9d9178f8181ab61babec46"
    sha256 ventura:       "0e436bcb8fb0b09056dca78ab457253a641d3fd5e556be24b704073685746f09"
    sha256 x86_64_linux:  "0bcddfd90524e9ffa6aaef0f6208d4177cdc36aa720b9250bc1b449b859e1e25"
  end

  depends_on "pkgconf" => :build
  depends_on "openldap"
  depends_on "openssl@3"

  uses_from_macos "bzip2"
  uses_from_macos "libxcrypt"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libtirpc"
    depends_on "linux-pam"
    depends_on "lz4"
    depends_on "xz"
    depends_on "zstd"
  end

  resource "pigeonhole" do
    url "https:pigeonhole.dovecot.orgreleases2.4dovecot-pigeonhole-2.4.0.tar.gz"
    sha256 "0ed08ae163ac39a9447200fbb42d7b3b05d35e91d99818dd0f4afd7ad1dbc753"
  end

  # `uoff_t` and `pluginsvar-expand-crypt` patches, upstream pr ref, https:github.comdovecotcorepull232
  patch do
    url "https:github.comdovecotcorecommitbbfab4976afdf38a7fa966752de33481f9d2c2e5.patch?full_index=1"
    sha256 "f5a77eeaf5978b75a6c7d1d9d4b7623679aec047c3dae63516105774ae6c04de"
  end
  patch :DATA

  def install
    args = %W[
      --libexecdir=#{libexec}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-bzlib
      --with-ldap
      --with-pam
      --with-sqlite
      --without-icu
    ]

    system ".configure", *args, *std_configure_args
    system "make", "install"

    resource("pigeonhole").stage do
      args = %W[
        --with-dovecot=#{lib}dovecot
        --with-ldap
      ]

      system ".configure", *args, *std_configure_args
      system "make"
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      For Dovecot to work, you may need to create a dovecot user
      and group depending on your configuration file options.
    EOS
  end

  service do
    run [opt_sbin"dovecot", "-F"]
    require_root true
    environment_variables PATH: std_service_path_env
    error_log_path var"logdovecotdovecot.log"
    log_path var"logdovecotdovecot.log"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}dovecot --version")

    cp_r share"docdovecotexample-config", testpath"example"
    (testpath"exampledovecot.conf").write <<~EOS
      # required in 2.4
      dovecot_config_version = 2.4.0
      dovecot_storage_version = 2.4.0

      base_dir = #{testpath}
      listen = *
      ssl = no

      default_login_user = #{ENV["USER"]}
      default_internal_user = #{ENV["USER"]}

      # reference other conf files
      # !include conf.d*.conf

      # same as 2.3
      log_path = syslog
      auth_mechanisms = plain
    EOS

    system bin"doveconf", "-c", testpath"exampledovecot.conf"
  end
end

__END__
diff --git asrclib-var-expand-cryptMakefile.in bsrclib-var-expand-cryptMakefile.in
index 6c8b1ad..b721ad5 100644
--- asrclib-var-expand-cryptMakefile.in
+++ bsrclib-var-expand-cryptMakefile.in
@@ -177,7 +177,11 @@ am__uninstall_files_from_dir = { \
 am__installdirs = "$(DESTDIR)$(moduledir)" \
 	"$(DESTDIR)$(pkginc_libdir)"
 LTLIBRARIES = $(module_LTLIBRARIES)
-var_expand_crypt_la_LIBADD =
+var_expand_crypt_la_LIBADD = \
+  ..libliblib.la \
+  ..lib-jsonlibjson.la \
+  ..lib-dcryptlibdcrypt.la \
+  ..lib-var-expandlibvar_expand.la
 am_var_expand_crypt_la_OBJECTS = var-expand-crypt.lo
 var_expand_crypt_la_OBJECTS = $(am_var_expand_crypt_la_OBJECTS)
 AM_V_lt = $(am__v_lt_@AM_V@)