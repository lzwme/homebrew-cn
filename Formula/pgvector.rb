class Pgvector < Formula
  desc "Open-source vector similarity search for Postgres"
  homepage "https://github.com/pgvector/pgvector"
  url "https://ghproxy.com/https://github.com/pgvector/pgvector/archive/v0.4.3.tar.gz"
  sha256 "91690bc2c49e9bef2e8f63d520f31663957ddf45c3b7aacc960a80898563fa70"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58a360f78a05751aeb2c97e6b741067a6aabd30c4ab9d70a8c8fcedc7b304f5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a191beaf035d531ff0f995561c07031f574aeb822c423d3fccd0903949d4342a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d115138d74d26df3322c4906080e8e05135ff86d2915f83e4640339e9087eec"
    sha256 cellar: :any_skip_relocation, ventura:        "d2776afe5e20a78bae0791c3d1a794f94a4688bc164dd9c3419b686ca4ad2fac"
    sha256 cellar: :any_skip_relocation, monterey:       "05bbf72e784a9081748cffb0fbbb75b2e4c0647a3dcbb59693add1a839377d4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e9d234f9bb6a26b6c556d04f2f1e425a199d2cf59136a678c37ccd14f33e07c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35c5b4c918e6a6ff0c7471f41b7d22007c6a415c90b2fc0bb50ab1ea2ab1c466"
  end

  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"

    system "make"
    (lib/postgresql.name).install "vector.so"
    (share/postgresql.name/"extension").install "vector.control"
    (share/postgresql.name/"extension").install Dir["sql/vector--*.sql"]
  end

  test do
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION vector;", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end