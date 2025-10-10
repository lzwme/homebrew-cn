class PgPartman < Formula
  desc "Partition management extension for PostgreSQL"
  homepage "https://github.com/pgpartman/pg_partman"
  url "https://ghfast.top/https://github.com/pgpartman/pg_partman/archive/refs/tags/v5.3.0.tar.gz"
  sha256 "059b0ecdc424a8f432f848ef4b5d168a1f5273d46ce10cba61af7a37273a3bfd"
  license "PostgreSQL"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c72acee55b9ac33b9fb519dcb6ee86ca3ffb3472f935cb8812e6fb4262154e04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9bb9dd12d1df3fb333c0a275f88aa2feba0d568a54c3593fc275c4e9abe9d8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54df8fe59479915aabe0083df844c8f8ae188ca97c159fa34447d5a67355547a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbeaa1c6ba605d51fab63f8f06ef6e8498cd7674a654d7492a67683a75d9a075"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25cc6985f0eadd0af844f26d9727b4eb4e116102141f59deaa6f182c79b991b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f4a748aa86c4b591372aa61c1b8075c05c1687ce57aafb9e1ffb60688905d62"
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