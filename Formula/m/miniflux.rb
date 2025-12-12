class Miniflux < Formula
  desc "Minimalist and opinionated feed reader"
  homepage "https://miniflux.app"
  url "https://ghfast.top/https://github.com/miniflux/v2/archive/refs/tags/2.2.15.tar.gz"
  sha256 "28cd9f7280d4807f53855de27ec1bad4cad68e29a469d7f38a2c5c4ad7404c56"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62193155be881f7c41cbddf679184a702fab1f2b4d8f57ce4faa161d50cdd013"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "682208711e9d3ac749305c3820e4b37aa4a607ece0261b1af377ad76a65353dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2510eae4b278b3a27eac89a0841fb557bf49bd8b5519f224968603d9f3b2f18a"
    sha256 cellar: :any_skip_relocation, sonoma:        "23d31d0f9c269b0a1eb1e4cd2416f15b9138b9faa4fcd90b8d6de36c78f276f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26f228c406c1e2d944af5dedb20acc7a4d54699d4812a807acbd7eb2d421a899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9ba29dc16917c010cc48091b1d34bd6e43fe20b0877103f2f56877cd1c53751"
  end

  depends_on "go" => :build
  depends_on "postgresql@18" => :test

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
    pg_bin = Formula["postgresql@18"].opt_bin
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