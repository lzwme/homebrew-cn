class Lighttpd < Formula
  desc "Small memory footprint, flexible web-server"
  homepage "https://www.lighttpd.net/"
  url "https://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.80.tar.xz"
  sha256 "cc5f0f71e8b2ee6bad545d1e91dfc3f954716c9174e7b352c2147add44f25bf3"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?lighttpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "aaa2f45f6e23469ae13bfbb3ff1ace41dd2f3f91cb189720eb77b6e8d468430e"
    sha256 arm64_sonoma:  "c482edafa97575dc647f08c5cdd746e0eed133e91796b48f68bc5eb16a93ab3a"
    sha256 arm64_ventura: "e8594cacc743c111e4fe06f5666cd89c5a08ac5d00489449adde6bfd15364c59"
    sha256 sonoma:        "8f31146abf561c27a9da4f790a67bd6bb33d3f9d8fd663fd90ea8ac7c45d1a66"
    sha256 ventura:       "ebcccf6416a478492d5a53a9ffaf7fda4a200d8618b7634cfa94d65d95862de4"
    sha256 arm64_linux:   "19a050bb3d482ad09c2e6d209e2e73841e0196ad3d97178202b5c4e23add32c3"
    sha256 x86_64_linux:  "9bafb5b932ed9058edac373d22c2a7c3eab1f17c13d713b3247461ff285e977a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openldap"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "bzip2"
  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  # default max. file descriptors; this option will be ignored if the server is not started as root
  MAX_FDS = 512

  def install
    args = %W[
      --disable-silent-rules
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
    system "./configure", *args, *std_configure_args
    system "make", "install"

    unless File.exist? etc/"lighttpd"
      (etc/"lighttpd").install "doc/config/lighttpd.conf", "doc/config/lighttpd.annotated.conf",
        "doc/config/modules.conf"
      (etc/"lighttpd/conf.d/").install Dir["doc/config/conf.d/*.conf"]
      inreplace etc + "lighttpd/lighttpd.annotated.conf" do |s|
        s.sub!(/^var\.log_root\s*=\s*".+"$/, "var.log_root    = \"#{var}/log/lighttpd\"")
        s.sub!(/^var\.server_root\s*=\s*".+"$/, "var.server_root = \"#{var}/www\"")
        s.sub!(/^var\.state_dir\s*=\s*".+"$/, "var.state_dir   = \"#{var}/lighttpd\"")
        s.sub!(/^var\.home_dir\s*=\s*".+"$/, "var.home_dir    = \"#{var}/lighttpd\"")
        s.sub!(/^var\.conf_dir\s*=\s*".+"$/, "var.conf_dir    = \"#{etc}/lighttpd\"")
        s.sub!(/^#server\.port\s*=\s*80$/, "server.port = 8080")
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
    system bin/"lighttpd", "-t", "-f", etc/"lighttpd/lighttpd.conf"
  end
end