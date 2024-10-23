class Uwsgi < Formula
  desc "Full stack for building hosting services"
  homepage "https:uwsgi-docs.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackagese146fb08706bc5d922584a5aaed1f73e7a17313310aa34615c74406112ea04a6uwsgi-2.0.27.tar.gz"
  sha256 "3ee5bfb7e6e9c93478c22aa8183eef35b95a2d5b14cca16172e67f135565c458"
  license "GPL-2.0-or-later"
  revision 1
  head "https:github.comunbituwsgi.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "307b7d6a364e78b15cfa828dd20c3ca2af375ada89ed5528c51de2cfcbf514eb"
    sha256 arm64_sonoma:  "f98f73e917ff6e3922636d0eb26755242fa7160eac55c602ffd45a9d8837dadf"
    sha256 arm64_ventura: "d7fa70e41832d86bc117555b5c61bb42b9b0ebfebb04bb72cb945f99f4659e66"
    sha256 sonoma:        "cf8a186c83de295e8ed927009c2464b491e51baee916aa7e307d889acd87a523"
    sha256 ventura:       "8e663a77d7f16771b348a5f36386248e943ccd3a0cf4749fc4b062e67e784211"
    sha256 x86_64_linux:  "9cd8cf3206897f9191d32fca3e22c567c20d68db781cd6265fb1d0174ad36a48"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.13"
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

  def python3
    "python3.13"
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