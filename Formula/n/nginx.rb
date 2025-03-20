class Nginx < Formula
  desc "HTTP(S) server and reverse proxy, and IMAPPOP3 proxy server"
  homepage "https:nginx.org"
  # Use "mainline" releases only (odd minor version number), not "stable"
  # See https:www.nginx.comblognginx-1-12-1-13-released for why
  url "https:nginx.orgdownloadnginx-1.27.4.tar.gz"
  sha256 "294816f879b300e621fa4edd5353dd1ec00badb056399eceb30de7db64b753b2"
  license "BSD-2-Clause"
  head "https:github.comnginxnginx.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{nginx[._-]v?(\d+(?:\.\d+)+)<a>\nmainline version}i)
  end

  bottle do
    sha256 arm64_sequoia: "8f204c0e74708663afe086aff63df82f5fa9860dfd8c8ce75f2cbc58973219f8"
    sha256 arm64_sonoma:  "6c37abbd7f5deb7ac94bf203a4aaea0201a1da56047f2be18d81a7a5722dc94a"
    sha256 arm64_ventura: "74e2108ad301b817950f3bba0a5bbeae4d0e73d66ff14d9e5de38429809c01d6"
    sha256 sonoma:        "e47e60d2b09fd7ee3a591b0ea110b40e375759842861d33b6ea2dfe36503f16c"
    sha256 ventura:       "f20cb5d189ed2f7b3feb77da7d8454e41284cff17c8604bb2053476c5b8e10fe"
    sha256 arm64_linux:   "425ef57069b5f0b11dab08a5500d12616a3ef57f614a13a7d20154b32ed5461e"
    sha256 x86_64_linux:  "24fdaebb46cf0741b946c57e789e672d3555697d887013b39a74071597f5a170"
  end

  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "xz" => :build
  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    # keep clean copy of source for compiling dynamic modules e.g. passenger
    (pkgshare"src").mkpath
    system "tar", "-cJf", (pkgshare"srcsrc.tar.xz"), "."

    # Changes default port to 8080
    inreplace "confnginx.conf" do |s|
      s.gsub! "listen       80;", "listen       8080;"
      s.gsub! "    #}\n\n}", "    #}\n    include servers*;\n}"
    end

    openssl = Formula["openssl@3"]
    pcre = Formula["pcre2"]

    cc_opt = "-I#{pcre.opt_include} -I#{openssl.opt_include}"
    ld_opt = "-L#{pcre.opt_lib} -L#{openssl.opt_lib}"

    args = %W[
      --prefix=#{prefix}
      --sbin-path=#{bin}nginx
      --with-cc-opt=#{cc_opt}
      --with-ld-opt=#{ld_opt}
      --conf-path=#{etc}nginxnginx.conf
      --pid-path=#{var}runnginx.pid
      --lock-path=#{var}runnginx.lock
      --http-client-body-temp-path=#{var}runnginxclient_body_temp
      --http-proxy-temp-path=#{var}runnginxproxy_temp
      --http-fastcgi-temp-path=#{var}runnginxfastcgi_temp
      --http-uwsgi-temp-path=#{var}runnginxuwsgi_temp
      --http-scgi-temp-path=#{var}runnginxscgi_temp
      --http-log-path=#{var}lognginxaccess.log
      --error-log-path=#{var}lognginxerror.log
      --with-compat
      --with-debug
      --with-http_addition_module
      --with-http_auth_request_module
      --with-http_dav_module
      --with-http_degradation_module
      --with-http_flv_module
      --with-http_gunzip_module
      --with-http_gzip_static_module
      --with-http_mp4_module
      --with-http_random_index_module
      --with-http_realip_module
      --with-http_secure_link_module
      --with-http_slice_module
      --with-http_ssl_module
      --with-http_stub_status_module
      --with-http_sub_module
      --with-http_v2_module
      --with-http_v3_module
      --with-ipv6
      --with-mail
      --with-mail_ssl_module
      --with-pcre
      --with-pcre-jit
      --with-stream
      --with-stream_realip_module
      --with-stream_ssl_module
      --with-stream_ssl_preread_module
    ]

    (pkgshare"srcconfigure_args.txt").write args.join("\n")

    if build.head?
      system ".autoconfigure", *args
    else
      system ".configure", *args
    end

    system "make", "install"
    if build.head?
      man8.install "docsmannginx.8"
    else
      man8.install "mannginx.8"
    end
  end

  def post_install
    (etc"nginxservers").mkpath
    (var"runnginx").mkpath

    # nginx's docroot is #{prefix}html, this isn't useful, so we symlink it
    # to #{HOMEBREW_PREFIX}varwww. The reason we symlink instead of patching
    # is so the user can redirect it easily to something else if they choose.
    html = prefix"html"
    dst = var"www"

    if dst.exist?
      rm_r(html)
      dst.mkpath
    else
      dst.dirname.mkpath
      html.rename(dst)
    end

    prefix.install_symlink dst => "html"

    # for most of this formula's life the binary has been placed in sbin
    # and Homebrew used to suggest the user copy the plist for nginx to their
    # ~LibraryLaunchAgents directory. So we need to have a symlink there
    # for such cases
    sbin.install_symlink bin"nginx" if rack.subdirs.any? { |d| d.join("sbin").directory? }
  end

  def caveats
    <<~EOS
      Docroot is: #{var}www

      The default port has been set in #{etc}nginxnginx.conf to 8080 so that
      nginx can run without sudo.

      nginx will load all files in #{etc}nginxservers.
    EOS
  end

  service do
    run [opt_bin"nginx", "-g", "daemon off;"]
    keep_alive false
    working_dir HOMEBREW_PREFIX
  end

  test do
    (testpath"nginx.conf").write <<~NGINX
      worker_processes 4;
      error_log #{testpath}error.log;
      pid #{testpath}nginx.pid;

      events {
        worker_connections 1024;
      }

      http {
        client_body_temp_path #{testpath}client_body_temp;
        fastcgi_temp_path #{testpath}fastcgi_temp;
        proxy_temp_path #{testpath}proxy_temp;
        scgi_temp_path #{testpath}scgi_temp;
        uwsgi_temp_path #{testpath}uwsgi_temp;

        server {
          listen 8080;
          root #{testpath};
          access_log #{testpath}access.log;
          error_log #{testpath}error.log;
        }
      }
    NGINX
    system bin"nginx", "-t", "-c", testpath"nginx.conf"
  end
end