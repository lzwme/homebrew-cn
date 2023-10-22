class PgCron < Formula
  desc "Run periodic jobs in PostgreSQL"
  homepage "https://github.com/citusdata/pg_cron"
  url "https://ghproxy.com/https://github.com/citusdata/pg_cron/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "9f4eb3193733c6fa93a6591406659aac54b82c24a5d91ffaf4ec243f717d94a0"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c294a3d8a7585bd4b916e024310be13810a8e86715c137e7814af8ed581aa5e1"
    sha256 cellar: :any,                 arm64_ventura:  "06b8a09d3fb974d116b35938d614af4c97f97694175ad0eed667664bccbc5052"
    sha256 cellar: :any,                 arm64_monterey: "5b2f6cfd5e2a576df15f7e77f35e7a1bded4b13cbaaaea617a191569e658b2c2"
    sha256 cellar: :any,                 sonoma:         "43837a961f837549b75a9f6fdda29d09ec27aa884fd9e70c97fa5314678bbfcb"
    sha256 cellar: :any,                 ventura:        "2c2ea81a120feffc0e6bea3d9c0f0b9a988ace65c337cdbb0b270edc6d459bc6"
    sha256 cellar: :any,                 monterey:       "6d3f19894fcd2dc173740b0c3ab089aea7c35c4a0e9f8c269a7df4e55acc12e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0718344de02cc3e52d659bc55464f804cafab8a07fd2cccc0a62f0a9fd88c51"
  end

  # upstream issue for running with pg@15, https://github.com/citusdata/pg_cron/issues/237
  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"

    system "make"
    (lib/postgresql.name).install "pg_cron.so"
    (share/postgresql.name/"extension").install Dir["pg_cron--*.sql"]
    (share/postgresql.name/"extension").install "pg_cron.control"
  end

  test do
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'pg_cron'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"pg_cron\";", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end