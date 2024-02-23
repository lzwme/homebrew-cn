class Lighttpd < Formula
  desc "Small memory footprint, flexible web-server"
  homepage "https:www.lighttpd.net"
  url "https:download.lighttpd.netlighttpdreleases-1.4.xlighttpd-1.4.74.tar.xz"
  sha256 "5c08736e83088f7e019797159f306e88ec729abe976dc98fb3bed71b9d3e53b5"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(href=.*?lighttpd[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "871acb24ad59dc848a7fd74b59b66e555e8cc2a8afdff08a69a464dcbe41e206"
    sha256 arm64_ventura:  "47dd2e25d1804a7c56eb3769dc5d1a3ef40b1c9c3fbec52849732203309c477d"
    sha256 arm64_monterey: "bc44cdc336280a800f2cefb0d6111a7254e187d76879f4c2f6bfc36f93b8072b"
    sha256 sonoma:         "fa2aeeea14d35b9dc32e6e193acfc8c298616fd4a37512890d1658b1b5344042"
    sha256 ventura:        "9626bba2313dcaf3ed1ded42638ff3af7c9605dc3a08ee365ac1e4bfaedd2e9e"
    sha256 monterey:       "a2271f7671e1b9c1f56b651a42654fd7a39e4d59bd33bd355fd19d8245a4eafe"
    sha256 x86_64_linux:   "ce7060b8ae058c57dec84583879b4677132419a3e85c637268f079af9ebf5436"
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

  # notified upstream in the related commit, lighttpdlighttpd1.4@4e0af6d
  resource "queue.h" do
    url "https:raw.githubusercontent.comlighttpdlighttpd1.44e0af6d8eba32fd1526a38e2b3db5fe76dab9912srccompatsysqueue.h"
    sha256 "8b284031772b1ba2035d9b05b24f2cb9b23e7bd324bcccb5e3fcc57d34aafa48"
  end

  def install
    # patch to add the missing queue.h file
    resource("queue.h").stage buildpath"srccompatsys"

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
    system ".autogen.sh"
    system ".configure", *args
    system "make", "install"

    unless File.exist? etc"lighttpd"
      (etc"lighttpd").install "docconfiglighttpd.conf", "docconfigmodules.conf"
      (etc"lighttpdconf.d").install Dir["docconfigconf.d*.conf"]
      inreplace etc + "lighttpdlighttpd.conf" do |s|
        s.sub!(^var\.log_root\s*=\s*".+"$, "var.log_root    = \"#{var}loglighttpd\"")
        s.sub!(^var\.server_root\s*=\s*".+"$, "var.server_root = \"#{var}www\"")
        s.sub!(^var\.state_dir\s*=\s*".+"$, "var.state_dir   = \"#{var}lighttpd\"")
        s.sub!(^var\.home_dir\s*=\s*".+"$, "var.home_dir    = \"#{var}lighttpd\"")
        s.sub!(^var\.conf_dir\s*=\s*".+"$, "var.conf_dir    = \"#{etc}lighttpd\"")
        s.sub!(^server\.port\s*=\s*80$, "server.port = 8080")
        s.sub!(%r{^server\.document-root\s*=\s*server_root \+ "htdocs"$}, "server.document-root = server_root")

        s.sub!(^server\.username\s*=\s*".+"$, 'server.username  = "_www"')
        s.sub!(^server\.groupname\s*=\s*".+"$, 'server.groupname = "_www"')
        s.sub!(^#server\.network-backend\s*=\s*"sendfile"$, 'server.network-backend = "writev"')

        # "max-connections == max-fds2",
        # https:redmine.lighttpd.netprojects1wikiServer_max-connectionsDetails
        s.sub!(^#server\.max-connections = .+$, "server.max-connections = " + (MAX_FDS  2).to_s)
      end
    end

    (var"loglighttpd").mkpath
    (var"wwwhtdocs").mkpath
    (var"lighttpd").mkpath
  end

  def caveats
    <<~EOS
      Docroot is: #{var}www

      The default port has been set in #{etc}lighttpdlighttpd.conf to 8080 so that
      lighttpd can run without sudo.
    EOS
  end

  service do
    run [opt_bin"lighttpd", "-D", "-f", etc"lighttpdlighttpd.conf"]
    keep_alive false
    error_log_path var"loglighttpdoutput.log"
    log_path var"loglighttpdoutput.log"
    working_dir HOMEBREW_PREFIX
  end

  test do
    system "#{bin}lighttpd", "-t", "-f", etc"lighttpdlighttpd.conf"
  end
end