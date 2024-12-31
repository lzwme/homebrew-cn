class PgPartman < Formula
  desc "Partition management extension for PostgreSQL"
  homepage "https:github.compgpartmanpg_partman"
  url "https:github.compgpartmanpg_partmanarchiverefstagsv5.2.3.tar.gz"
  sha256 "be4283d5891831c554b328a7a0ec59a2b108cf5417c0f2ee38375d407d1d5bc7"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a32264b10d1151a51f32a45a70790e1d5cc170cd40cd7e0e2ce83aebb7b92a21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39e8bf0e02cf65720d663b4a6e031d1101ecd7a940e1b95bc2ae319ec6624701"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0aadc8585922758da42ba4c5123f5f41fe27716be6b690369d0a984796e4e051"
    sha256 cellar: :any_skip_relocation, sonoma:        "356430a5eaf35fdadd0d452a7fc58e6bbdf635ac1d056c590822661fab1c8e53"
    sha256 cellar: :any_skip_relocation, ventura:       "2ad5025c66bb79e93ccf58f0c2695a9af844403396232b1c6c34599131c5b662"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb4d295337ddb711cc2f4aaee616a5813038fc7579d3a95c0165de99ff2f92d7"
  end

  depends_on "postgresql@14" => [:build, :test]
  depends_on "postgresql@17" => [:build, :test]

  def postgresqls
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("postgresql@") }
  end

  def install
    postgresqls.each do |postgresql|
      ENV["PG_CONFIG"] = postgresql.opt_bin"pg_config"

      system "make"
      system "make", "install", "bindir=#{bin}",
                                "docdir=#{doc}",
                                "datadir=#{sharepostgresql.name}",
                                "pkglibdir=#{libpostgresql.name}"
      system "make", "clean"
    end
  end

  test do
    ENV["LC_ALL"] = "C"
    postgresqls.each do |postgresql|
      pg_ctl = postgresql.opt_bin"pg_ctl"
      psql = postgresql.opt_bin"psql"
      port = free_port

      datadir = testpathpostgresql.name
      system pg_ctl, "initdb", "-D", datadir
      (datadir"postgresql.conf").write <<~EOS, mode: "a+"

        shared_preload_libraries = 'pg_partman_bgw'
        port = #{port}
      EOS
      system pg_ctl, "start", "-D", datadir, "-l", testpath"log-#{postgresql.name}"
      begin
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"pg_partman\";", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end