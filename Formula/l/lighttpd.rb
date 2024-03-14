class Lighttpd < Formula
  desc "Small memory footprint, flexible web-server"
  homepage "https:www.lighttpd.net"
  url "https:download.lighttpd.netlighttpdreleases-1.4.xlighttpd-1.4.75.tar.xz"
  sha256 "8b721ca939d312afaa6ef31dcbd6afb5161ed385ac828e6fccd4c5b76be189d6"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(href=.*?lighttpd[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "faef6711a71611b1b4d329806f562918c01c4aba12937c1cd72f6d0cf6994b63"
    sha256 arm64_ventura:  "3965819a87645eb03a7e7d63e0559be82176466fa2aecc844f97e97ea230b9d2"
    sha256 arm64_monterey: "316e88e19ec2fb0429e37b3bba934b24dff6b0e8d9e6ad88729bc11462507584"
    sha256 sonoma:         "d2f21e5bf0d4b221480188069407c6939727cbfbeb7fb8a607ccf92cf3b507ff"
    sha256 ventura:        "6bd82f22ff0d37770625844ab2cc10c4e817f76fff443d47506aa9772ad4583e"
    sha256 monterey:       "e95e5cfeb4729ba1dbc662afc9baf222719f123eeefaa6b73ca752e74e9b4849"
    sha256 x86_64_linux:   "4588e2ff293427c1c6cf2af07fcd99006957eb09a0bbb89cc311b8176ada25d2"
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