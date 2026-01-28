class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://ghfast.top/https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.4.0.tar.gz"
  sha256 "e44d7cf7ee305d07b474a9ccfd6032fb9e3d1ffba87a716be40654d1e4efbc40"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^@core/sync-service@(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c467e6f67c4a46f499282cdbf6a826ebf16e296ecc50aa54d225acca05939438"
    sha256 cellar: :any,                 arm64_sequoia: "d1be20f456d337d1c63ade64ce3925605cd580b56258769411ae7f9754581fe7"
    sha256 cellar: :any,                 arm64_sonoma:  "5fbae071e275b4a4aa2f64f5fc6160da8f483fb64eb6d8e2b9e315b15daab385"
    sha256 cellar: :any,                 sonoma:        "d446c154e681717955f9be543f19999dc1db51b166d75f47a471146d988111fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56fe3afb1a47ead17751ef9bef71cb7043222fb39ebba1735f97f1a71d6ba829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c2fcc4a59bc16f67bae55d4acddfffb7cb4ef7089a7236383ae7f3640f7f7e5"
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