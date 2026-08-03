class Nginx < Formula
  desc "HTTP(S) server and reverse proxy, and IMAP/POP3 proxy server"
  homepage "https://nginx.org/"
  # Use "mainline" releases only (odd minor version number), not "stable"
  # See https://www.nginx.com/blog/nginx-1-12-1-13-released/ for why
  url "https://nginx.org/download/nginx-1.31.3.tar.gz"
  sha256 "a7657c50811c2d92d9895395e8b873ef60398142c4db21eb647811c38f6dd525"
  license "BSD-2-Clause"
  compatibility_version 8
  head "https://github.com/nginx/nginx.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{nginx[._-]v?(\d+(?:\.\d+)+)</a>\nmainline version}i)
  end

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "e38a9e6aaeea0002e67698427b89ff1f89485da331991eb9cd2a0b0844cf100c"
    sha256 arm64_sequoia: "ea69ac14a0f68af9922a77fd217ece47a951bb513d1ea1cf938be04924e64a3f"
    sha256 arm64_sonoma:  "bbeed7fbafa85a8d70bc0271f6394291dfafb2f6858a03200fe99d030336e71b"
    sha256 sonoma:        "200f04c3d861a3d3825cf8cbe08750a147fe08961873a08c38f609484b45afd9"
    sha256 arm64_linux:   "7e46bd9db5aa03cd97cf9427058adc419f0b21ce96913703fba8ae2a0ae553f8"
    sha256 x86_64_linux:  "5ba2bc50a144574f641ddce7cfad67f33ccee024a7314c031aac442a27d9c683"
  end

  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "xz" => :build
  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Allow broken symlink to be created by post install
  skip_clean "html"

  def install
    # keep clean copy of source for compiling dynamic modules e.g. passenger
    (pkgshare/"src").mkpath
    system "tar", "-cJf", (pkgshare/"src/src.tar.xz"), "."

    # Changes default port to 8080
    inreplace "conf/nginx.conf" do |s|
      s.gsub! "listen       80;", "listen       8080;"
      s.gsub! "    #}\n\n}", "    #}\n    include servers/*;\n}"
    end

    cc_opt = "-I#{formula_opt_include("pcre2")} -I#{formula_opt_include("openssl@3")}"
    ld_opt = "-L#{formula_opt_lib("pcre2")} -L#{formula_opt_lib("openssl@3")}"

    args = %W[
      --prefix=#{prefix}
      --sbin-path=#{bin}/nginx
      --with-cc-opt=#{cc_opt}
      --with-ld-opt=#{ld_opt}
      --conf-path=#{etc}/nginx/nginx.conf
      --pid-path=#{var}/run/nginx.pid
      --lock-path=#{var}/run/nginx.lock
      --http-client-body-temp-path=#{var}/run/nginx/client_body_temp
      --http-proxy-temp-path=#{var}/run/nginx/proxy_temp
      --http-fastcgi-temp-path=#{var}/run/nginx/fastcgi_temp
      --http-uwsgi-temp-path=#{var}/run/nginx/uwsgi_temp
      --http-scgi-temp-path=#{var}/run/nginx/scgi_temp
      --http-log-path=#{var}/log/nginx/access.log
      --error-log-path=#{var}/log/nginx/error.log
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

    (pkgshare/"src/configure_args.txt").write args.join("\n")

    if build.head?
      system "./auto/configure", *args
    else
      system "./configure", *args
    end

    system "make", "install"
    if build.head?
      man8.install "docs/man/nginx.8"
    else
      man8.install "man/nginx.8"
    end

    touch (etc/"nginx/servers").mkpath/".keepme"
    (var/"run/nginx").mkpath

    # nginx's docroot is #{prefix}/html, this isn't useful, so we symlink it
    # to #{HOMEBREW_PREFIX}/var/www. The reason we symlink instead of patching
    # is so the user can redirect it easily to something else if they choose.
    libexec.install prefix/"html"
    prefix.install_symlink var/"www" => "html"
  end

  post_install_steps do
    unless_path_exists "{{var}}/www" do
      move "{{libexec}}/html", "{{var}}/www"
    end
  end

  def caveats
    <<~EOS
      Docroot is: #{var}/www

      The default port has been set in #{etc}/nginx/nginx.conf to 8080 so that
      nginx can run without sudo.

      nginx will load all files in #{etc}/nginx/servers/.
    EOS
  end

  service do
    run [opt_bin/"nginx", "-g", "daemon off;"]
    keep_alive false
    working_dir HOMEBREW_PREFIX
  end

  test do
    (testpath/"nginx.conf").write <<~NGINX
      worker_processes 4;
      error_log #{testpath}/error.log;
      pid #{testpath}/nginx.pid;

      events {
        worker_connections 1024;
      }

      http {
        client_body_temp_path #{testpath}/client_body_temp;
        fastcgi_temp_path #{testpath}/fastcgi_temp;
        proxy_temp_path #{testpath}/proxy_temp;
        scgi_temp_path #{testpath}/scgi_temp;
        uwsgi_temp_path #{testpath}/uwsgi_temp;

        server {
          listen 8080;
          root #{testpath};
          access_log #{testpath}/access.log;
          error_log #{testpath}/error.log;
        }
      }
    NGINX
    system bin/"nginx", "-t", "-c", testpath/"nginx.conf"
  end
end