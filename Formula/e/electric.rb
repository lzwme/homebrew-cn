class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://ghfast.top/https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.1.13.tar.gz"
  sha256 "ec502c7d3d9c436920b5b65d9c7dbe9ad56bb519ee3cb1fabd209abd584aa865"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ac3f37b227fc8869b433313fb22d7a7b5af0a65e3e2be5b4f3c8e7ab0bf76f5a"
    sha256 cellar: :any,                 arm64_sequoia: "7bd33fe0303bcb13b415220b6cd53f9cf5ea3964aa4760e0a763fbee4d050c16"
    sha256 cellar: :any,                 arm64_sonoma:  "2debf8d65301f76f1e18ed563faf1cd5da49a1f64dbef7b901c6088b85b26115"
    sha256 cellar: :any,                 sonoma:        "e9068b17756fcb61a60a12d795276bb7015848e2a0b626e59ae91c84f466d78a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9f80c0c9fd0497ec6dea3fb0ccd77c6623e5fc63f10f2f26013b59f58b64f29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56e7f4afde167a37f1c84ecafe70cf17110e86e8014e75d52a09df7bd26e8b38"
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
      spawn bin/"electric", "start"

      output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{ENV["ELECTRIC_PORT"]}/v1/health")
      assert_match "active", output
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end