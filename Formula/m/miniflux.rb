class Miniflux < Formula
  desc "Minimalist and opinionated feed reader"
  homepage "https://miniflux.app"
  url "https://ghfast.top/https://github.com/miniflux/v2/archive/refs/tags/2.3.0.tar.gz"
  sha256 "19590c117273801f9e87eb163a0486d3d05a5eee31e215026a5ceb32b0328a8c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "619c55c66ced78c74513fa127015808f3015983e3462d58cb0d96383ce801552"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "866d6657742a52d821f3d7820e69a89391d9f7704d129a0e9b06dc4a7517b421"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60884102a175332f391246c837dde8806a2888f14a850e1f0d17d65017cd5240"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3abc1de7cb0d29eb58f049f418b84683401643b5e046ea87147873b7168a955"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76a8ac92c9a8d124bf129545a6bb3f39e8271e38162121e2dc8cd912c670df46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6daa627dbb5e5588a422c7edaf26429f547d9ddd72fd1d356d7a67b8161baa4"
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
        assert_equal "OK",
          shell_output("curl --silent --retry 5 --retry-connrefused http://127.0.0.1:#{miniflux_port}/healthcheck")
      ensure
        Process.kill "TERM", miniflux_pid
        Process.wait miniflux_pid
      end
    ensure
      system pg_ctl, "stop", "-D", datadir
    end
  end
end