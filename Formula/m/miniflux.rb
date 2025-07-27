class Miniflux < Formula
  desc "Minimalist and opinionated feed reader"
  homepage "https://miniflux.app"
  url "https://ghfast.top/https://github.com/miniflux/v2/archive/refs/tags/2.2.11.tar.gz"
  sha256 "20f6e7da292f7fd7e9989c40f203ad6c9d58fdf26ba3fbbd08da618fa36b8d2e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a763f6f7e9d4b54b8606546eaeb852162e253a024d156f97ad7b8603ac582989"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1862b0450d6d14675285d8d5734fd4c9e4c6407690d5f96111f121cf0f287a82"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "582d69c8c54759e12db9ca5d631601c5168fcbeb56a7ba67b1c009de2ea6e931"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a5f9a0c2e5fb7e729cc64700f2189d76dde4ba4b3c885200b07d01933018057"
    sha256 cellar: :any_skip_relocation, ventura:       "c6eb879c4f276ffddec2f3d5b4c256d80ed090cc1457c4c916a3cd65f065fed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79e3e75b13fdb948167e6c72851f380da5dd3dc4b6447d11c050b5dba9582397"
  end

  depends_on "go" => :build
  depends_on "postgresql@17" => :test

  def install
    ldflags = %W[
      -s -w
      -X miniflux.app/v2/internal/version.Version=#{version}
      -X miniflux.app/v2/internal/version.Commit=#{tap.user}
      -X miniflux.app/v2/internal/version.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  service do
    run [opt_bin/"miniflux", "-c", etc/"miniflux.conf"]
    keep_alive true
    error_log_path var/"log/miniflux.log"
    log_path var/"log/miniflux.log"
    working_dir var
  end

  test do
    ENV["LC_ALL"] = "C"

    pg_port = free_port
    pg_bin = Formula["postgresql@17"].opt_bin
    pg_ctl = pg_bin/"pg_ctl"

    datadir = testpath/"postgres"
    system pg_ctl, "init", "-D", datadir

    (datadir/"postgresql.conf").write <<~EOS, mode: "a+"
      port = #{pg_port}
      unix_socket_directories = '#{datadir}'
    EOS

    system pg_ctl, "start", "-D", datadir, "-l", testpath/"postgres.log"
    begin
      system pg_bin/"createdb", "-h", datadir, "-p", pg_port.to_s, "miniflux_test"

      # Run Miniflux
      miniflux_port = free_port
      (testpath/"miniflux.conf").write <<~CONF
        DATABASE_URL=postgres://localhost:#{pg_port}/miniflux_test?sslmode=disable
        ADMIN_USERNAME=admin
        ADMIN_PASSWORD=test123
        CREATE_ADMIN=1
        RUN_MIGRATIONS=1
        LOG_LEVEL=debug
        LISTEN_ADDR=127.0.0.1:#{miniflux_port}
      CONF

      miniflux_pid = spawn(bin/"miniflux", "-c", testpath/"miniflux.conf")
      begin
        sleep 2
        assert_equal "OK", shell_output("curl -s http://127.0.0.1:#{miniflux_port}/healthcheck")
      ensure
        Process.kill "TERM", miniflux_pid
        Process.wait miniflux_pid
      end
    ensure
      system pg_ctl, "stop", "-D", datadir
    end
  end
end