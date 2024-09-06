class Uwsgi < Formula
  desc "Full stack for building hosting services"
  homepage "https:uwsgi-docs.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackages3a7a4c910bdc9d32640ba89f8d1dc256872c2b5e64830759f7dc346815f5b3b1uwsgi-2.0.26.tar.gz"
  sha256 "86e6bfcd4dc20529665f5b7777193cdc48622fb2c59f0a7f1e3dc32b3882e7f9"
  license "GPL-2.0-or-later"
  head "https:github.comunbituwsgi.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "8a0fe851ae6fc032d9edb666e21f2688285503d5f3680954262bae520664a606"
    sha256 arm64_ventura:  "0f8603be2a9a008af7676a3563baa3e3150d1d52a4ccab1641a63a2ab69f9dc7"
    sha256 arm64_monterey: "e4fb04cd0e8271c2389976835ad753fa4fff24f39858519083b2cc12bcef5a36"
    sha256 sonoma:         "ff4331647474243f77905308c0399b6eac8b07f97f2336ecd5b04a83b11e0165"
    sha256 ventura:        "aa6b6ecaad5d23ee694ca705759cd2f687b8c577335105ec8caa37ae3e602798"
    sha256 monterey:       "abd4002d0e8c7d9d220aa4c3db11d208f0629ceac9602389afa09fe0d47d4804"
    sha256 x86_64_linux:   "fcc5a66132b65c34b849729b0151b191e21b572b71ba4d703cd4ae8797a7b888"
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