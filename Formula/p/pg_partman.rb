class PgPartman < Formula
  desc "Partition management extension for PostgreSQL"
  homepage "https://github.com/pgpartman/pg_partman"
  url "https://ghfast.top/https://github.com/pgpartman/pg_partman/archive/refs/tags/v5.4.1.tar.gz"
  sha256 "5540706a53dc3cddbed3340e2806a8c976a44bfc45b77f636466878346f547a8"
  license "PostgreSQL"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "607f8a6f5f1683be7b0396acff76090043423c0f2b9134658d8a122576cafb03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "755392477acd37232fa2225f65f433d1450cb2b3ff9b4e05ba80c6d62c35dfb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b938d0b8845bec7d8fe8302d7831e1dc084ac48e0217609af5f498393b31fc5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfcc09552c3af875df72a48c3c3d2cd2da340e893cf29c59a2a03494f56a3b6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "828f6affc24182b96026e49fe0ea3e649f189d3287f7b17c930d6bb56eb2cf6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad5963221a516acaa6d45005d65b9907e998393b2bf81920c97ff9cb53f5c4be"
  end

  depends_on "postgresql@17" => [:build, :test]
  depends_on "postgresql@18" => [:build, :test]

  def postgresqls
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("postgresql@") }
  end

  def install
    odie "Too many postgresql dependencies!" if postgresqls.count > 2

    postgresqls.each do |postgresql|
      ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"

      system "make"
      system "make", "install", "bindir=#{bin}",
                                "docdir=#{doc}",
                                "datadir=#{share/postgresql.name}",
                                "pkglibdir=#{lib/postgresql.name}"
      system "make", "clean"
    end
  end

  test do
    ENV["LC_ALL"] = "C"
    postgresqls.each do |postgresql|
      pg_ctl = postgresql.opt_bin/"pg_ctl"
      psql = postgresql.opt_bin/"psql"
      port = free_port

      datadir = testpath/postgresql.name
      system pg_ctl, "initdb", "-D", datadir
      (datadir/"postgresql.conf").write <<~EOS, mode: "a+"

        shared_preload_libraries = 'pg_partman_bgw'
        port = #{port}
      EOS
      system pg_ctl, "start", "-D", datadir, "-l", testpath/"log-#{postgresql.name}"
      begin
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"pg_partman\";", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end