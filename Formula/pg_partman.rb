class PgPartman < Formula
  desc "Partition management extension for PostgreSQL"
  homepage "https://github.com/pgpartman/pg_partman"
  url "https://ghproxy.com/https://github.com/pgpartman/pg_partman/archive/refs/tags/v4.7.2.tar.gz"
  sha256 "8ca9cf2a56bde591b0d0526cf5db54a2c9691fcfa514eebb419f8c394eb9d17a"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "973279863324b0d0641e18b884ba6a44ec88c96f560e60342695a75a96ffbe32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1e9f7fc116c5f3f692ed16a5937ff0c1fc2d586e0c07284fa3e708eeba9e52c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "827b1cf57561a64f0142fc5404f8977074715c6ad5f64bc9c413a1aa2b870565"
    sha256 cellar: :any_skip_relocation, ventura:        "76470f9294c0a8a0c6e409c15a0e1859d84ea842dea5c69b2087e7d81d2c0e40"
    sha256 cellar: :any_skip_relocation, monterey:       "f9a6b0880e48a584c60b634507422c5946181d2337bbd826406d8d0d511c744f"
    sha256 cellar: :any_skip_relocation, big_sur:        "cad072844166a607243801f7e0ad622c80fbaf729d72d7f36e5f2f73323c8e8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bd167cc98893ee9ad7e30cd1b84b7939b3bde26ae4c53c2d5f44b72c4ce3de0"
  end

  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"

    system "make"
    (lib/postgresql.name).install "src/pg_partman_bgw.so"
    (share/postgresql.name/"extension").install "pg_partman.control"
    (share/postgresql.name/"extension").install Dir["sql/pg_partman--*.sql"]
    (share/postgresql.name/"extension").install Dir["updates/pg_partman--*.sql"]
  end

  test do
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'pg_partman_bgw'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"pg_partman\";", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end