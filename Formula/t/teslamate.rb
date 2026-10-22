class Teslamate < Formula
  desc "Self-hosted data logger for your Tesla"
  homepage "https://docs.teslamate.org"
  url "https://ghfast.top/https://github.com/teslamate-org/teslamate/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "b27b77ba878211f59f4c6399dcbf434063f36c9cee06d581475834804a242728"
  license "AGPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "812c9f84ada8c65130cec0bdc55d0bc2ea856f1af7e10b52b4df2d84a8af980c"
    sha256 cellar: :any, arm64_tahoe:       "5680d900281148cb2a03a8bc3a49ab39f73c6daf37bfceb599e5f305510d65fb"
    sha256 cellar: :any, arm64_sequoia:     "b91a53c3370806b034de58f018c57946113deb7dcbcd74942a786e3b67a4a2bd"
    sha256 cellar: :any, arm64_linux:       "b08408496f111590909b6aacd8d39310ec2602f6e1d9f9c20966394b3faf3428"
    sha256 cellar: :any, x86_64_linux:      "59050a2af964d6cf4d66ae43b1c037b6f45b38096e16c8d214c17295f39c70dc"
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

    # Use brewed ca-certificates PEM file instead of the bundled copy
    cacerts = libexec.glob("lib/castore-*/priv/cacerts.pem").fetch(0)
    rm cacerts
    cacerts.make_relative_symlink Formula["openssl@4"].pkgetc/"cert.pem"
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