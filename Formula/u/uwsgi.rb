class Uwsgi < Formula
  desc "Full stack for building hosting services"
  homepage "https:uwsgi-docs.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackagesc5d672d625b5664468df51c5a082668b3f127cc0b154f7bb22763ac71b081d6auwsgi-2.0.25.tar.gz"
  sha256 "a0463d00a31f382a560b631adfbcf0a342c748ce04b3408e5bae1b401653d217"
  license "GPL-2.0-or-later"
  head "https:github.comunbituwsgi.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "272be41ef3b7b27e3c75e5421a0e01255b599152e795038af690760845e471d0"
    sha256 arm64_ventura:  "acc2290ddd895c79ef9c707f6ed11b896ddfa87d9fb9e6b047b90814cd968781"
    sha256 arm64_monterey: "86fc2509893b0ac3a2dd38ffd4833a5a4a5b0e1fce9be98b3b3da7a52641e028"
    sha256 sonoma:         "24f8b3e43493b1fb1d81dcbe69a8a5f862a3173f24969160d29ee92138ee7bab"
    sha256 ventura:        "a4cc173f468f37ff2dfd970ab19cd0bddcb840b54382f60aad4660b2efa8e495"
    sha256 monterey:       "1b6314bdecd056448380231f65129aba5d8b73353eca019e851802b0859ff6f2"
    sha256 x86_64_linux:   "9aca70907620223f9d4c5cad591f65d1ac28ccad7eb84b7728257bc65512b7f1"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "pcre" # PCRE2 issue: https:github.comunbituwsgiissues2486
  depends_on "python@3.12"
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