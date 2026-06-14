class Teslamate < Formula
  desc "Self-hosted data logger for your Tesla"
  homepage "https://docs.teslamate.org"
  url "https://ghfast.top/https://github.com/teslamate-org/teslamate/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "ff5a69943b922b9ffa716ab8813df89927d5a7c343e712758ecfc36874e13500"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fe1c2b41a8144afa68347c0c939e806339d54c7d410ecef1d0637f2ff7388356"
    sha256 cellar: :any, arm64_sequoia: "588d38e8911bbbe701b2803a6d4dd71619720754eff165f709569cabad038e04"
    sha256 cellar: :any, arm64_sonoma:  "f5a80f8a90667ad574150f829282cf8821ab4ea8f19736b591b056f8bbd04a05"
    sha256 cellar: :any, sonoma:        "541f6c85aa16f4009c37663a280ebb0d015015867821b34089b37dc184138ed5"
    sha256 cellar: :any, arm64_linux:   "5274ddff9ce30671911449d1153f4ee7b24e028a00074a80c90dbd6a5262383c"
    sha256 cellar: :any, x86_64_linux:  "b011c4c46a190209f8bdd78d354f620c03f91732c595740da4eabd84ded40c42"
  end

  depends_on "elixir" => :build
  depends_on "erlang" => :build
  depends_on "node" => :build
  depends_on "postgresql@18" => :test
  depends_on "openssl@3"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # See https://docs.teslamate.org/docs/installation/debian/
    system "mix", "local.hex", "--force"
    system "mix", "local.rebar", "--force"
    system "mix", "deps.get", "--only", "prod"
    system "npm", "install", "--prefix", "./assets", *std_npm_args(prefix: false)
    system "npm", "run", "deploy", "--prefix", "./assets"

    with_env("MIX_ENV" => "prod") do
      system "mix", "do", "phx.digest,", "release", "--overwrite"
    end

    touch buildpath/"teslamate.env"
    etc.install "teslamate.env"
    libexec.install Dir["_build/prod/rel/teslamate/*"]
    bin.install_symlink Dir["#{libexec}/bin/teslamate"]

    # Corresponds to https://github.com/teslamate-org/teslamate/blob/main/entrypoint.sh
    (bin/"teslamate_brew_services").write <<~EOS
      #!/bin/bash
      set -e
      source #{etc}/teslamate.env
      #{bin}/teslamate eval "TeslaMate.Release.migrate"
      exec #{bin}/teslamate start
    EOS
  end

  service do
    run opt_bin/"teslamate_brew_services"
    keep_alive true
    log_path var/"log/teslamate.log"
    error_log_path var/"log/teslamate.log"
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
      system pg_bin/"createdb", "-h", datadir, "-p", pg_port.to_s, "teslamate"
      system pg_bin/"createuser", "-h", datadir, "-p", pg_port.to_s, "-s", "teslamate"

      # Run Teslamate with the test database
      ENV["DATABASE_USER"] = "teslamate"
      ENV["DATABASE_PASS"] = ""
      ENV["DATABASE_NAME"] = "teslamate"
      ENV["DATABASE_HOST"] = "127.0.0.1"
      ENV["DATABASE_PORT"] = pg_port.to_s
      ENV["DISABLE_MQTT"] = "true"
      log_file = testpath/"teslamate_test.log"
      File.open(log_file, "w") do |file|
        pid = spawn(opt_bin/"teslamate_brew_services", out: file, err: file)
        sleep 20
        system opt_bin/"teslamate", "stop"
        Process.kill("KILL", pid)
        Process.wait(pid)
      end
      output = log_file.read
      assert_match "Access TeslaMateWeb.Endpoint at http://localhost", output
    ensure
      system pg_ctl, "stop", "-D", datadir
    end
  end
end