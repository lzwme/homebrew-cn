class Uwsgi < Formula
  desc "Full stack for building hosting services"
  homepage "https:uwsgi-docs.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackagese146fb08706bc5d922584a5aaed1f73e7a17313310aa34615c74406112ea04a6uwsgi-2.0.27.tar.gz"
  sha256 "3ee5bfb7e6e9c93478c22aa8183eef35b95a2d5b14cca16172e67f135565c458"
  license "GPL-2.0-or-later"
  head "https:github.comunbituwsgi.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "406f6148141cf2dc39642509f9824f1194f45594671c403e22021f387d31a3c4"
    sha256 arm64_sonoma:  "7046ea7b89717b42bc3bad1ade91da787dd75ef1cb3b3125dd6f3f6995838f88"
    sha256 arm64_ventura: "aaf2ae027abd418337f7d61e86217392debf3cef30405c2efd4d064836ef6236"
    sha256 sonoma:        "a081e3ca5de740c4ac25d8f8f26bf109f190e752470b9de8bc78bee743c1a0d2"
    sha256 ventura:       "0204e8b97e173f10d0119f81d54017543bdea15af77fed0b58ab1ac9f83dd52d"
    sha256 x86_64_linux:  "f5cd1e574fd5317bf912c6bef2c352401f3c5fda30c9c76f1503659722129e47"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.12"
  depends_on "sqlite"
  depends_on "yajl"

  uses_from_macos "curl"
  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "openldap"
  uses_from_macos "perl"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    openssl = Formula["openssl@3"]
    ENV.prepend "CFLAGS", "-I#{openssl.opt_include}"
    ENV.prepend "LDFLAGS", "-L#{openssl.opt_lib}"

    (buildpath"buildconfbrew.ini").write <<~EOS
      [uwsgi]
      ssl = true
      json = yajl
      xml = libxml2
      yaml = embedded
      inherit = base
      plugin_dir = #{libexec}uwsgi
      embedded_plugins = null
    EOS

    python3 = "python3.12"
    system python3, "uwsgiconfig.py", "--verbose", "--build", "brew"

    plugins = %w[airbrake alarm_curl asyncio cache
                 carbon cgi cheaper_backlog2 cheaper_busyness
                 corerouter curl_cron dumbloop dummy
                 echo emperor_amqp fastrouter forkptyrouter gevent
                 http logcrypto logfile ldap logpipe logsocket
                 msgpack notfound pam ping psgi pty rawrouter
                 router_basicauth router_cache router_expires
                 router_hash router_http router_memcached
                 router_metrics router_radius router_redirect
                 router_redis router_rewrite router_static
                 router_uwsgi router_xmldir rpc signal spooler
                 sqlite3 sslrouter stats_pusher_file
                 stats_pusher_socket symcall syslog
                 transformation_chunked transformation_gzip
                 transformation_offload transformation_tofile
                 transformation_toupper ugreen webdav zergpool]
    plugins << "alarm_speech" if OS.mac?
    plugins << "cplusplus" if OS.linux?

    (libexec"uwsgi").mkpath
    plugins.each do |plugin|
      system python3, "uwsgiconfig.py", "--verbose", "--plugin", "plugins#{plugin}", "brew"
    end

    system python3, "uwsgiconfig.py", "--verbose", "--plugin", "pluginspython", "brew", "python3"

    bin.install "uwsgi"
  end

  service do
    run [opt_bin"uwsgi", "--uid", "_www", "--gid", "_www", "--master", "--die-on-term", "--autoload", "--logto",
         HOMEBREW_PREFIX"varloguwsgi.log", "--emperor", HOMEBREW_PREFIX"etcuwsgiapps-enabled"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end

  test do
    (testpath"helloworld.py").write <<~EOS
      def application(env, start_response):
        start_response('200 OK', [('Content-Type','texthtml')])
        return [b"Hello World"]
    EOS

    port = free_port

    pid = fork do
      exec "#{bin}uwsgi --http-socket 127.0.0.1:#{port} --protocol=http --plugin python3 -w helloworld"
    end
    sleep 2

    begin
      assert_match "Hello World", shell_output("curl localhost:#{port}")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end