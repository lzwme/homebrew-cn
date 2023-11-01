class Lighttpd < Formula
  desc "Small memory footprint, flexible web-server"
  homepage "https://www.lighttpd.net/"
  url "https://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.73.tar.xz"
  sha256 "818816d0b314b0aa8728a7076513435f6d5eb227f3b61323468e1f10dbe84ca8"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?lighttpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "c57995f70ea9cb413c58722c8768f8ead5e12951a6433715bd27b2367c15628c"
    sha256 arm64_ventura:  "b472357fa71d76a8e545c09d2766560f4beeee1085f1c871c0747d40d986f5b8"
    sha256 arm64_monterey: "d8d64a5e80d5de97652b12cb244b1f0bf5c34772d97074740635a35240e71692"
    sha256 sonoma:         "2806d72a167c99e95d7e07cc8169c817b5df06c8bff6c3cbc87b62e389c8cb18"
    sha256 ventura:        "c250cd9cfa62cbcd5cdfb2ad57bc5f505284abd468faa59067ed3487fdb1ae03"
    sha256 monterey:       "02b33f8ec4fb4bc23375ac819a6195ffffbeeea608f34a492ea68a5f304c1eb0"
    sha256 x86_64_linux:   "c0996965a54e0a6fb3b917547007b3edeceed4d5fe05909f41632018e275d41e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openldap"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "libxcrypt"

  # default max. file descriptors; this option will be ignored if the server is not started as root
  MAX_FDS = 512

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sbindir=#{bin}
      --with-bzip2
      --with-ldap
      --with-openssl
      --without-pcre
      --with-pcre2
      --with-zlib
    ]

    # autogen must be run, otherwise prebuilt configure may complain
    # about a version mismatch between included automake and Homebrew's
    system "./autogen.sh"
    system "./configure", *args
    system "make", "install"

    unless File.exist? etc/"lighttpd"
      (etc/"lighttpd").install "doc/config/lighttpd.conf", "doc/config/modules.conf"
      (etc/"lighttpd/conf.d/").install Dir["doc/config/conf.d/*.conf"]
      inreplace etc + "lighttpd/lighttpd.conf" do |s|
        s.sub!(/^var\.log_root\s*=\s*".+"$/, "var.log_root    = \"#{var}/log/lighttpd\"")
        s.sub!(/^var\.server_root\s*=\s*".+"$/, "var.server_root = \"#{var}/www\"")
        s.sub!(/^var\.state_dir\s*=\s*".+"$/, "var.state_dir   = \"#{var}/lighttpd\"")
        s.sub!(/^var\.home_dir\s*=\s*".+"$/, "var.home_dir    = \"#{var}/lighttpd\"")
        s.sub!(/^var\.conf_dir\s*=\s*".+"$/, "var.conf_dir    = \"#{etc}/lighttpd\"")
        s.sub!(/^server\.port\s*=\s*80$/, "server.port = 8080")
        s.sub!(%r{^server\.document-root\s*=\s*server_root \+ "/htdocs"$}, "server.document-root = server_root")

        s.sub!(/^server\.username\s*=\s*".+"$/, 'server.username  = "_www"')
        s.sub!(/^server\.groupname\s*=\s*".+"$/, 'server.groupname = "_www"')
        s.sub!(/^#server\.network-backend\s*=\s*"sendfile"$/, 'server.network-backend = "writev"')

        # "max-connections == max-fds/2",
        # https://redmine.lighttpd.net/projects/1/wiki/Server_max-connectionsDetails
        s.sub!(/^#server\.max-connections = .+$/, "server.max-connections = " + (MAX_FDS / 2).to_s)
      end
    end

    (var/"log/lighttpd").mkpath
    (var/"www/htdocs").mkpath
    (var/"lighttpd").mkpath
  end

  def caveats
    <<~EOS
      Docroot is: #{var}/www

      The default port has been set in #{etc}/lighttpd/lighttpd.conf to 8080 so that
      lighttpd can run without sudo.
    EOS
  end

  service do
    run [opt_bin/"lighttpd", "-D", "-f", etc/"lighttpd/lighttpd.conf"]
    keep_alive false
    error_log_path var/"log/lighttpd/output.log"
    log_path var/"log/lighttpd/output.log"
    working_dir HOMEBREW_PREFIX
  end

  test do
    system "#{bin}/lighttpd", "-t", "-f", etc/"lighttpd/lighttpd.conf"
  end
end