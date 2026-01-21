class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://ghfast.top/https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.3.1.tar.gz"
  sha256 "a7875781b94195dcfb0ad917727d72bb57124f2e9461b48e651eb7116dff77b9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^@core/sync-service@(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a28dc2a5fe945e09dbc6e417f1212256f4307104775b5a4954985b974493b3fb"
    sha256 cellar: :any,                 arm64_sequoia: "4cf5511e967d8033a8bad8161f2341d24f0336840d28f50a25976ef57556491f"
    sha256 cellar: :any,                 arm64_sonoma:  "e3ece5afb44213fda5827c52c43e53c0c7c8c3854e89b16cd30dff979a301338"
    sha256 cellar: :any,                 sonoma:        "08aaea9ae85636eacdc7fd70319b24c83dfb130ef1996e3b76a61b03171b3113"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "414f69091329026992ad0cb880de99c0c43b3235ba7550e05cffab69d038e252"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b5d0b4d1230d93b800cf68cf7f01984b413b4aa1c674a63d7f74951f48eaf36"
  end

  depends_on "elixir" => :build
  depends_on "postgresql@17" => :test
  depends_on "erlang"
  depends_on "openssl@3"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    ENV["MIX_ENV"] = "prod"
    ENV["MIX_TARGET"] = "application"

    cd "packages/sync-service" do
      system "mix", "deps.get"
      system "mix", "compile"
      system "mix", "release"
      libexec.install Dir["_build/application_prod/rel/electric/*"]
      bin.write_exec_script libexec.glob("bin/*")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/electric version")

    ENV["LC_ALL"] = "C"

    postgresql = Formula["postgresql@17"]
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
      wal_level = logical
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"

    begin
      ENV["DATABASE_URL"] = "postgres://#{ENV["USER"]}:@localhost:#{port}/postgres?sslmode=disable"
      ENV["ELECTRIC_INSECURE"] = "true"
      ENV["ELECTRIC_PORT"] = free_port.to_s

      mkdir_p testpath/"persistent/shapes/single_stack/.meta/backups/shape_status_backups"

      spawn bin/"electric", "start"
      sleep 5 if OS.mac? && Hardware::CPU.intel?

      output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{ENV["ELECTRIC_PORT"]}/v1/health")
      assert_match "active", output
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end