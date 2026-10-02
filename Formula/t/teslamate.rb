class Teslamate < Formula
  desc "Self-hosted data logger for your Tesla"
  homepage "https://docs.teslamate.org"
  url "https://ghfast.top/https://github.com/teslamate-org/teslamate/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "b27b77ba878211f59f4c6399dcbf434063f36c9cee06d581475834804a242728"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5e5f641bb146a54e5f5fb719416c1ae4090941104aee08b95af14e1bbeebe205"
    sha256 cellar: :any, arm64_tahoe:       "31baf7e293f89cfc858aad5d483f856e464226556b196a7af533b787b263d033"
    sha256 cellar: :any, arm64_sequoia:     "204df32d836b0597d38703e7d64945f04ca5315facdd667edfac36b37e527fb2"
    sha256 cellar: :any, arm64_linux:       "8933b9aa579e206256875d6f96baad10b99b6f3cddd6e50c36258043e8cf7751"
    sha256 cellar: :any, x86_64_linux:      "1ab997fa20bb349fe93f06cb06d4b2a7d42abe44d7a2d6df142d389e1c4f1d4f"
  end

  depends_on "elixir" => :build
  depends_on "erlang" => :build
  depends_on "node" => :build
  depends_on "postgresql@18" => :test
  depends_on "openssl@4"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # See https://docs.teslamate.org/docs/installation/unsupported/debian
    cd "elixir"
    system "mix", "local.hex", "--force"
    system "mix", "local.rebar", "--force"
    system "mix", "deps.get", "--only", "prod"
    system "npm", "install", "--prefix", "./assets", *std_npm_args(prefix: false)
    system "npm", "run", "deploy", "--prefix", "./assets"

    with_env("MIX_ENV" => "prod") do
      system "mix", "do", "phx.digest,", "release", "--overwrite"
    end

    touch "teslamate.env"
    etc.install "teslamate.env"
    libexec.install Dir["_build/prod/rel/teslamate/*"]
    bin.install_symlink Dir["#{libexec}/bin/teslamate"]

    # Corresponds to https://github.com/teslamate-org/teslamate/blob/main/entrypoint.sh
    (bin/"teslamate_brew_services").write <<~BASH
      #!/bin/bash
      set -e
      source #{etc}/teslamate.env
      #{bin}/teslamate eval "TeslaMate.Release.migrate"
      exec #{bin}/teslamate start
    BASH
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
    pg_bin = formula_opt_bin("postgresql@18")
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
      endpoint_message = "Access TeslaMateWeb.Endpoint at http://localhost"

      File.open(log_file, "w") do |file|
        pid = spawn(opt_bin/"teslamate_brew_services", out: file, err: file)
        sleep 1 until log_file.read.include?(endpoint_message)
        system opt_bin/"teslamate", "stop"
        Process.kill("KILL", pid)
        Process.wait(pid)
      end
      assert_match endpoint_message, log_file.read
    ensure
      system pg_ctl, "stop", "-D", datadir
    end
  end
end